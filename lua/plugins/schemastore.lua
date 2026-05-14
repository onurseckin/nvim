-- schemastore.nvim — bundles the entire SchemaStore.org catalog (~150 schemas)
-- of YAML/JSON configs: GitHub Actions, docker-compose, Kubernetes, tsconfig,
-- package.json, .eslintrc, .prettierrc, OpenAPI, Cargo, and ~140 more.
--
-- Wired into yamlls and jsonls in lsp.lua so opening any of these files gives
-- you completion + validation + hover docs out of the box.
return {
  'b0o/schemastore.nvim',
  lazy = true,
}
