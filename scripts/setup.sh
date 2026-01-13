#!/bin/bash
#
# Claude Code & Cursor Setup Script
# Supports: Linux, macOS
#
# Usage:
#   ./setup.sh                    # Interactive mode
#   ./setup.sh --claude           # Claude Code only
#   ./setup.sh --cursor           # Cursor only
#   ./setup.sh --all              # Both Claude Code and Cursor
#   ./setup.sh --symlink          # Use symlinks instead of copy
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Target directories
CLAUDE_GLOBAL_DIR="$HOME/.claude"
CURSOR_GLOBAL_DIR="$HOME/.cursor"

# Source directories
GLOBAL_TEMPLATES="$REPO_DIR/global-templates"
PROJECT_TEMPLATES="$REPO_DIR/project-templates"

# Flags
INSTALL_CLAUDE=false
INSTALL_CURSOR=false
USE_SYMLINK=false
BACKUP=true

print_banner() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║     Claude Code & Cursor Setup Script                     ║"
    echo "║     Sub-agents & Skills Templates                         ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

detect_os() {
    case "$(uname -s)" in
        Linux*)     OS="Linux";;
        Darwin*)    OS="macOS";;
        *)          OS="Unknown";;
    esac
    print_info "Detected OS: $OS"
}

backup_existing() {
    local target="$1"
    local name="$2"

    if [ -e "$target" ] && [ "$BACKUP" = true ]; then
        local backup_path="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backing up existing $name to $backup_path"
        mv "$target" "$backup_path"
    fi
}

install_claude_global() {
    print_info "Installing Claude Code global templates..."

    # Create ~/.claude directory
    mkdir -p "$CLAUDE_GLOBAL_DIR"

    # Backup existing files
    [ -f "$CLAUDE_GLOBAL_DIR/CLAUDE.md" ] && backup_existing "$CLAUDE_GLOBAL_DIR/CLAUDE.md" "CLAUDE.md"
    [ -f "$CLAUDE_GLOBAL_DIR/settings.json" ] && backup_existing "$CLAUDE_GLOBAL_DIR/settings.json" "settings.json"
    [ -d "$CLAUDE_GLOBAL_DIR/agents" ] && backup_existing "$CLAUDE_GLOBAL_DIR/agents" "agents"
    [ -d "$CLAUDE_GLOBAL_DIR/skills" ] && backup_existing "$CLAUDE_GLOBAL_DIR/skills" "skills"

    if [ "$USE_SYMLINK" = true ]; then
        # Symlink mode
        ln -sf "$GLOBAL_TEMPLATES/CLAUDE.md" "$CLAUDE_GLOBAL_DIR/CLAUDE.md"
        ln -sf "$GLOBAL_TEMPLATES/settings.json" "$CLAUDE_GLOBAL_DIR/settings.json"
        ln -sf "$GLOBAL_TEMPLATES/agents" "$CLAUDE_GLOBAL_DIR/agents"
        ln -sf "$GLOBAL_TEMPLATES/skills" "$CLAUDE_GLOBAL_DIR/skills"
        print_success "Created symlinks for Claude Code global config"
    else
        # Copy mode
        cp "$GLOBAL_TEMPLATES/CLAUDE.md" "$CLAUDE_GLOBAL_DIR/"
        cp "$GLOBAL_TEMPLATES/settings.json" "$CLAUDE_GLOBAL_DIR/"
        cp -r "$GLOBAL_TEMPLATES/agents" "$CLAUDE_GLOBAL_DIR/"
        cp -r "$GLOBAL_TEMPLATES/skills" "$CLAUDE_GLOBAL_DIR/"
        print_success "Copied Claude Code global config"
    fi

    echo ""
    print_success "Claude Code global setup complete!"
    echo "  - CLAUDE.md:     $CLAUDE_GLOBAL_DIR/CLAUDE.md"
    echo "  - settings.json: $CLAUDE_GLOBAL_DIR/settings.json"
    echo "  - agents/:       $CLAUDE_GLOBAL_DIR/agents/ (6 agents)"
    echo "  - skills/:       $CLAUDE_GLOBAL_DIR/skills/ (37 skills, 9 categories)"
}

install_cursor_global() {
    print_info "Installing Cursor global rules..."

    # Create ~/.cursor/rules directory
    mkdir -p "$CURSOR_GLOBAL_DIR/rules"

    # Convert CLAUDE.md to Cursor rules format
    local cursor_rules_file="$CURSOR_GLOBAL_DIR/rules/global.mdc"

    if [ -f "$cursor_rules_file" ]; then
        backup_existing "$cursor_rules_file" "global.mdc"
    fi

    # Create Cursor-compatible rules from CLAUDE.md
    cat > "$cursor_rules_file" << 'CURSOR_RULES'
---
description: Global rules for all projects
globs:
alwaysApply: true
---

# Global Cursor Rules

## Default Behavior

- Respond to user in Korean, use English internally
- Prioritize code quality and stability
- Prefer concise and clear explanations
- Avoid unnecessary comments or documentation

## Code Style

- Indentation: 2 spaces (JavaScript/TypeScript), 4 spaces (Python, Rust)
- Type safety: TypeScript strict mode, Python type hints
- Functions follow single responsibility principle
- Use clear and meaningful variable names

## Role Profiles

### Data Engineer Mode
- Idempotency first
- Consider data lineage tracking
- Include data quality validation

### Fullstack Developer Mode
- Prefer rapid prototyping
- User experience focused design
- Consider accessibility (a11y)

### DevOps Mode
- Infrastructure as Code principles
- Security first (least privilege)
- Always include monitoring/alerting

## Preferred Tools/Frameworks

| Category | Tools |
|----------|-------|
| Frontend | React, Next.js, TypeScript |
| Backend | Python, FastAPI |
| Database | PostgreSQL, Redis, ClickHouse |
| DevOps | Docker, Kubernetes, Terraform |
| Data | Polars, Delta Lake, Apache Arrow |
| Testing | Playwright, pytest, Vitest |
CURSOR_RULES

    print_success "Cursor global rules created"

    # Also create legacy .cursorrules in home for compatibility
    local legacy_rules="$HOME/.cursorrules"
    if [ -f "$legacy_rules" ]; then
        backup_existing "$legacy_rules" ".cursorrules"
    fi

    cp "$cursor_rules_file" "$legacy_rules" 2>/dev/null || true

    echo ""
    print_success "Cursor global setup complete!"
    echo "  - Rules: $CURSOR_GLOBAL_DIR/rules/global.mdc"
    echo ""
    print_warning "Note: Cursor global User Rules are UI-based."
    echo "  Go to: Settings > Cursor Settings > Rules > User Rules"
    echo "  Paste the content from: $cursor_rules_file"
}

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --claude      Install Claude Code global templates only"
    echo "  --cursor      Install Cursor global rules only"
    echo "  --all         Install both Claude Code and Cursor"
    echo "  --symlink     Use symlinks instead of copying files"
    echo "  --no-backup   Don't backup existing files"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --all              # Install both with copy"
    echo "  $0 --claude --symlink # Claude only with symlinks"
    echo "  $0                    # Interactive mode"
}

interactive_mode() {
    echo ""
    echo "Select installation target:"
    echo "  1) Claude Code only"
    echo "  2) Cursor only"
    echo "  3) Both Claude Code and Cursor"
    echo "  4) Exit"
    echo ""
    read -p "Enter choice [1-4]: " choice

    case $choice in
        1) INSTALL_CLAUDE=true ;;
        2) INSTALL_CURSOR=true ;;
        3) INSTALL_CLAUDE=true; INSTALL_CURSOR=true ;;
        4) echo "Exiting."; exit 0 ;;
        *) print_error "Invalid choice"; exit 1 ;;
    esac

    echo ""
    read -p "Use symlinks instead of copy? [y/N]: " symlink_choice
    case $symlink_choice in
        [Yy]*) USE_SYMLINK=true ;;
        *) USE_SYMLINK=false ;;
    esac
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --claude)
            INSTALL_CLAUDE=true
            shift
            ;;
        --cursor)
            INSTALL_CURSOR=true
            shift
            ;;
        --all)
            INSTALL_CLAUDE=true
            INSTALL_CURSOR=true
            shift
            ;;
        --symlink)
            USE_SYMLINK=true
            shift
            ;;
        --no-backup)
            BACKUP=false
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main
print_banner
detect_os

# Check if source exists
if [ ! -d "$GLOBAL_TEMPLATES" ]; then
    print_error "Global templates not found at: $GLOBAL_TEMPLATES"
    exit 1
fi

# Interactive mode if no flags
if [ "$INSTALL_CLAUDE" = false ] && [ "$INSTALL_CURSOR" = false ]; then
    interactive_mode
fi

echo ""
print_info "Installation mode: $([ "$USE_SYMLINK" = true ] && echo "Symlink" || echo "Copy")"
print_info "Backup enabled: $BACKUP"
echo ""

# Install selected targets
if [ "$INSTALL_CLAUDE" = true ]; then
    install_claude_global
    echo ""
fi

if [ "$INSTALL_CURSOR" = true ]; then
    install_cursor_global
    echo ""
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Setup complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code / Cursor to apply changes"
echo "  2. For project-level setup, copy project-templates/ to your project"
echo ""
