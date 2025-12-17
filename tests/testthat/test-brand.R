# Tests for C40 brand configuration functions

test_that("c40_brand returns full configuration", {
  brand <- c40_brand()
  expect_type(brand, "list")
  expect_true("color" %in% names(brand))
  expect_true("typography" %in% names(brand))
  expect_true("meta" %in% names(brand))
})

test_that("c40_brand returns specific sections", {
  colours <- c40_brand("color")
  expect_type(colours, "list")
  expect_true("palette" %in% names(colours))

  typography <- c40_brand("typography")
  expect_type(typography, "list")
  expect_true("fonts" %in% names(typography))
})

test_that("c40_brand errors on invalid section", {
  expect_error(c40_brand("invalid_section"))
})

test_that("c40_colours returns core palette", {
  cols <- c40_colours("core")
  expect_type(cols, "character")
  expect_true(length(cols) >= 5)
  # Check for hex format
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", cols)))
})

test_that("c40_colours returns qualitative palette", {
  cols <- c40_colours("qualitative")
  expect_type(cols, "character")
  expect_length(cols, 7)
})

test_that("c40_colours returns divergent palette", {
  cols <- c40_colours("divergent")
  expect_type(cols, "character")
  expect_length(cols, 5)
})

test_that("c40_colours returns dichotomous palette", {
  cols <- c40_colours("dichotomous")
  expect_type(cols, "character")
  expect_length(cols, 2)
})

test_that("c40_colours tints work correctly", {
  core <- c40_colours("core", tint = "core")
  mid <- c40_colours("core", tint = "mid")
  light <- c40_colours("core", tint = "light")

  expect_type(core, "character")
  expect_type(mid, "character")
  expect_type(light, "character")
})

test_that("c40_colours names parameter works", {
  named <- c40_colours("core", names = TRUE)
  unnamed <- c40_colours("core", names = FALSE)

  expect_true(!is.null(names(named)))
  expect_null(names(unnamed))
})

test_that("c40_fonts returns Figtree as base font", {
  font <- c40_fonts("base")
  expect_equal(font, "Figtree")
})

test_that("c40_fonts returns all settings when NULL", {
  fonts <- c40_fonts(NULL)
  expect_type(fonts, "list")
  expect_true("fonts" %in% names(fonts))
})

test_that("c40_text_colour returns correct values", {
  # Navy background should use white text
  expect_equal(c40_text_colour("#053D6B"), "#FFFFFF")

  # Yellow background should use black text
  expect_equal(c40_text_colour("#FED939"), "#000000")

  # White background should use black text
  expect_equal(c40_text_colour("#FFFFFF"), "#000000")
})

test_that("c40_brand_path returns valid path", {
  path <- c40_brand_path()
  expect_type(path, "character")
  expect_true(file.exists(path))
  expect_true(grepl("_brand\\.yml$", path))
})
