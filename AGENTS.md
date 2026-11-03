# Repository guidance

## Slidev skill prerequisite

- Use the official Slidev skill, installed at `.agents/skills/slidev/SKILL.md`.
- Keep agent skills and repository-level agent configuration under `.agents`; do not create tool-specific mirrors such as `.claude`.
- This repository uses Bun. Translate package-manager examples from the skill to their Bun equivalents rather than introducing npm, pnpm, or Yarn.

## Fast iteration and verification

- Optimize routine editing for fast feedback. Prefer a focused live-browser check for visual changes and `bun run build` for production validation.
- Do not generate or regenerate PDF, PPTX, PNG, or other exported slide artifacts unless the user explicitly requests an export or asks to validate an exported artifact.
- In particular, do not run `make pdf`, `make ppt`, `slidev export`, or the corresponding package scripts as routine verification after slide edits. Exporting is comparatively slow and is not part of the default definition of done.
- Existing exported files may be stale during normal iteration; this is expected. Do not refresh them proactively.
- When using a temporary Slidev development server for validation, use an available port, avoid disrupting a server already running for the user, and stop any server started by the agent when validation is complete.

## Project conventions

- The main presentation source is `slides.md` and shared styling is in `style.css`.
- Keep presenter notes in the HTML comments associated with each slide.
- Preserve the common footer in `global-bottom.vue`; do not duplicate it in individual slides.
- Keep the deck licensed under CC BY 4.0 and retain Ryan Djurovich's attribution and `ryan0x44.com` where licensing or author metadata is shown.
