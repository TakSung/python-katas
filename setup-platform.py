#!/usr/bin/env python3
"""
Platform Setup Script for Python Katas

This script sets up platform-specific files (scripts and Claude skills)
for Windows or Linux/macOS environments.

Usage:
    python setup-platform.py           # Auto-detect platform
    python setup-platform.py windows   # Force Windows setup
    python setup-platform.py linux     # Force Linux/macOS setup
"""

import argparse
import platform
import shutil
import sys
from pathlib import Path


def detect_platform():
    """Detect the current operating system platform.

    Returns:
        str: 'windows' or 'linux'

    Raises:
        ValueError: If the platform is not supported
    """
    system = platform.system().lower()
    if system == "windows":
        return "windows"
    elif system in ["linux", "darwin"]:
        return "linux"
    else:
        raise ValueError(
            f"Unsupported platform: {system}\n"
            "Supported platforms: Windows, Linux, macOS"
        )


def ensure_katarc_exists():
    """Initialize .katarc from .katarc.example if it doesn't exist.

    Returns:
        bool: True if .katarc was created, False if it already existed

    Raises:
        FileNotFoundError: If .katarc.example is not found
    """
    katarc_path = Path(".katarc")
    example_path = Path(".katarc.example")

    if katarc_path.exists():
        return False

    if not example_path.exists():
        raise FileNotFoundError(
            ".katarc.example not found!\n"
            "This file should be in the project root directory."
        )

    shutil.copy2(example_path, katarc_path)
    print(f"✅ Created .katarc from .katarc.example")
    return True


def copy_platform_files(platform_name):
    """Copy platform-specific files to the project root.

    Args:
        platform_name (str): 'windows' or 'linux'

    Raises:
        FileNotFoundError: If the platform directory doesn't exist
    """
    platform_dir = Path(f"platforms/{platform_name}")

    if not platform_dir.exists():
        raise FileNotFoundError(
            f"Platform directory not found: {platform_dir}\n"
            "Expected structure: platforms/{windows|linux}/"
        )

    # Copy scripts
    scripts_src = platform_dir / "scripts"
    scripts_dst = Path("scripts")

    if scripts_src.exists():
        print(f"📝 Copying {platform_name} scripts...")
        scripts_dst.mkdir(parents=True, exist_ok=True)

        for script_file in scripts_src.iterdir():
            if script_file.is_file():
                shutil.copy2(script_file, scripts_dst / script_file.name)
                print(f"   ├─ {script_file.name}")

        # Set execute permissions for shell scripts (Linux/macOS only)
        if platform_name == "linux":
            for script in scripts_dst.glob("*.sh"):
                script.chmod(0o755)
                print(f"   ├─ chmod +x {script.name}")

    # Copy SKILL.md files
    skills_src = platform_dir / ".claude/skills"
    skills_dst = Path(".claude/skills")

    if skills_src.exists():
        print(f"📝 Copying {platform_name} SKILL.md files...")
        skills_dst.mkdir(parents=True, exist_ok=True)

        for skill_dir in skills_src.iterdir():
            if skill_dir.is_dir():
                skill_name = skill_dir.name
                dst_skill_dir = skills_dst / skill_name
                dst_skill_dir.mkdir(parents=True, exist_ok=True)

                for skill_file in skill_dir.iterdir():
                    if skill_file.name == "SKILL.md":
                        shutil.copy2(skill_file, dst_skill_dir / skill_file.name)
                        print(f"   ├─ {skill_name}/SKILL.md")


def merge_katarc_patch(platform_name, env_type="venv", conda_name="katas"):
    """Merge platform-specific and environment-specific settings into .katarc.

    This function:
    1. Removes any existing platform settings from .katarc
    2. Appends new platform settings from .katarc.patch.{env_type}
    3. For conda, replaces {conda_name} placeholder with actual name

    Args:
        platform_name (str): 'windows' or 'linux'
        env_type (str): 'venv' or 'conda' (default: 'venv')
        conda_name (str): Conda environment name (default: 'katas')

    Raises:
        FileNotFoundError: If .katarc or .katarc.patch.{env_type} is not found
    """
    katarc_path = Path(".katarc")
    patch_path = Path(f"platforms/{platform_name}/.katarc.patch.{env_type}")

    if not katarc_path.exists():
        raise FileNotFoundError(".katarc not found. This should have been created earlier.")

    if not patch_path.exists():
        raise FileNotFoundError(
            f"Platform patch file not found: {patch_path}\n"
            f"Expected: platforms/{platform_name}/.katarc.patch.{env_type}"
        )

    print(f"📄 Updating .katarc with {platform_name}/{env_type} settings...")

    # Read existing .katarc
    content = katarc_path.read_text(encoding="utf-8")

    # Remove existing platform settings
    lines = [
        line for line in content.splitlines()
        if not line.startswith("PLATFORM=")
        and not line.startswith("SCRIPT_EXT=")
        and not line.startswith("ENV_TYPE=")
        and not line.startswith("CONDA_ENV_NAME=")
        and not line.startswith("VENV_ACTIVATE=")
        and not line.strip().startswith("# Platform:")
        and not line.strip().startswith("# Environment:")
        and not line.strip().startswith("# Generated by setup-platform.py")
        and not line.strip().startswith("# This content will be appended")
    ]

    # Remove trailing empty lines
    while lines and not lines[-1].strip():
        lines.pop()

    # Read patch content (skip header comments)
    patch_content = patch_path.read_text(encoding="utf-8")

    # Replace {conda_name} placeholder if conda
    if env_type == "conda":
        patch_content = patch_content.replace("{conda_name}", conda_name)

    patch_lines = patch_content.splitlines()
    platform_settings = [
        line for line in patch_lines
        if line.strip()
        and not line.strip().startswith("#")
    ]

    # Append new platform settings
    lines.append("")
    lines.append(f"# Platform: {platform_name.capitalize()}")
    lines.append("# Generated by setup-platform.py")
    lines.extend(platform_settings)
    lines.append("")

    # Write back to .katarc
    katarc_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"   ├─ PLATFORM={platform_name}")
    for setting in platform_settings:
        if "=" in setting:
            print(f"   ├─ {setting}")


def main():
    """Main entry point for the setup script."""
    parser = argparse.ArgumentParser(
        description="Setup platform-specific files for Python Katas",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python setup-platform.py                              # Auto-detect platform, use venv
  python setup-platform.py windows                      # Force Windows, use venv
  python setup-platform.py linux                        # Force Linux/macOS, use venv
  python setup-platform.py --env conda                  # Auto-detect, use conda (env: katas)
  python setup-platform.py --env conda --conda-name ml  # Auto-detect, use conda (env: ml)
  python setup-platform.py linux --env conda            # Force Linux, use conda

This script will:
  1. Create .katarc from .katarc.example (if not exists)
  2. Copy platform-specific scripts to scripts/
  3. Copy platform-specific SKILL.md files to .claude/skills/
  4. Update .katarc with platform and environment settings
        """
    )
    parser.add_argument(
        "platform",
        nargs="?",
        choices=["windows", "linux"],
        help="Target platform (auto-detected if not specified)"
    )
    parser.add_argument(
        "--env",
        choices=["venv", "conda"],
        default="venv",
        help="Python environment type (default: venv)"
    )
    parser.add_argument(
        "--conda-name",
        default="katas",
        help="Conda environment name (only for --env conda, default: katas)"
    )

    args = parser.parse_args()

    try:
        # Determine platform
        if args.platform:
            platform_name = args.platform
            print(f"🔍 Platform: {platform_name} (manually specified)")
        else:
            platform_name = detect_platform()
            print(f"🔍 Platform: {platform_name} (auto-detected)")

        # Get environment type
        env_type = args.env
        print(f"🐍 Environment: {env_type}")

        print()

        # Step 1: Ensure .katarc exists
        created = ensure_katarc_exists()
        if not created:
            print("ℹ️  .katarc already exists (preserving existing settings)")
        print()

        # Step 2: Copy platform-specific files
        copy_platform_files(platform_name)
        print()

        # Step 3: Merge platform and environment settings
        conda_name = args.conda_name if env_type == "conda" else "katas"
        merge_katarc_patch(platform_name, env_type, conda_name)
        print()

        # Success
        print("=" * 60)
        print("✅ Setup complete!")
        print("=" * 60)
        print()
        print(f"Your environment is now configured for {platform_name.upper()} with {env_type.upper()}.")
        print()
        print("Next steps:")
        print("  1. Review .katarc and adjust CURRENT_KATA if needed")

        if env_type == "venv":
            print("  2. Run: uv venv && uv sync")
        else:  # conda
            print(f"  2. Run: conda create -n {conda_name} python=3.13")
            print(f"     Then: conda activate {conda_name}")

        print("  3. Try: ./scripts/git-helper.sh status" if platform_name == "linux"
              else "  3. Try: scripts\\git-helper.bat status")
        print()

    except (ValueError, FileNotFoundError) as e:
        print(f"\n❌ Error: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
