# AI Agent Guidelines for c40tools

## Language & Terminology

### Output Language
- **All generated content must be in British English**
- This includes: code comments, documentation, commit messages, file names, variable names, and any written output
- Use British spellings: colour, organisation, behaviour, licence, etc.

### Terminology Restrictions
- **NEVER mention "Claude" in any document, code comment, or external reference**
- Use these alternatives instead:
  - "AI Agent"
  - "Automated Assistant"
  - "AI-powered review"
  - Simply omit the agent reference when not necessary

### Interaction Language
- User interactions may be in Spanish, English, or other languages
- Always respond in the user's language for conversation
- Generated artefacts (code, docs, files) must always be in British English

---

## Code Standards

### R Package Conventions
- Follow tidyverse style guide
- Use Roxygen2 for documentation
- Prefer `snake_case` for function and variable names
- Use explicit namespace calls for external functions (e.g., `dplyr::filter()`)

### Documentation
- All documentation must be in British English
- Use clear, concise language
- Include examples in `@examples` sections
- Document all exported functions

### Git Commits
- Write commit messages in British English
- Use conventional commit format when applicable
- Keep messages concise but descriptive

---

## Project-Specific Context

### About c40tools
- Internal R package for C40 Cities Climate Leadership Group
- Used by multiple international users
- Primary functions: Data Warehouse connection, city data validation, GHG emissions calculations, C40 brand visualisations

### Key Considerations
- Package must work across different operating systems
- Database connections must always be properly closed
- Avoid hardcoding city-specific logic in functions
- Maintain backwards compatibility when possible

---

## Brand Guidelines Reference

The official C40 brand guidelines are located at:
- **Path:** `inst/brand/c40-brand-guidelines-2025-09.pdf`
- **Access in R:** `system.file("brand", "c40-brand-guidelines-2025-09.pdf", package = "c40tools")`
- **Brand YAML:** `inst/brand/_brand.yml` - Machine-readable brand specification

### When Working on Colour/Style Functions

Before modifying or creating functions related to:
- Colour palettes (`c40_pallets()`, `scale_fill_c40()`, `scale_color_c40()`)
- Visual themes
- Plot styling
- Any brand-related visual elements

**Always consult the brand guidelines** to ensure compliance with C40's visual identity standards.

---

## Review Checklist

When reviewing or generating code, ensure:
- [ ] British English spelling throughout
- [ ] No AI agent name references in output
- [ ] Proper error handling with informative messages
- [ ] Database connections closed with `on.exit()`
- [ ] Functions use explicit namespace calls
- [ ] Documentation is complete and accurate
- [ ] Colour/style functions align with brand guidelines
