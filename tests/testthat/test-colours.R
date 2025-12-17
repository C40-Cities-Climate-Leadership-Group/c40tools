# Tests for C40 colour functions
# Updated for September 2025 brand guidelines

test_that("c40_colors returns correct hex values for named colours", {
  # Core palette colours (September 2025)
  expect_equal(c40_colors("yellow"), "#FED939")
  expect_equal(c40_colors("blue"), "#23BCED")
  expect_equal(c40_colors("navy"), "#053D6B")
  expect_equal(c40_colors("green"), "#03C245")
  expect_equal(c40_colors("forest"), "#056608")
  expect_equal(c40_colors("red"), "#FF614A")
  expect_equal(c40_colors("purple"), "#7E65C1")
})

test_that("c40_colors returns all colours when called without arguments", {
  all_colours <- c40_colors()
  expect_length(all_colours, 7)  # Updated: 7 core colours
  expect_type(all_colours, "character")
})

test_that("c40_colors returns named vector when name = TRUE", {
  named_colour <- c40_colors("green", name = TRUE)
  expect_named(named_colour, "green")
  expect_equal(unname(named_colour), "#03C245")
})

test_that("c40_colors returns unnamed vector when name = FALSE", {
  unnamed_colour <- c40_colors("green", name = FALSE)
  expect_null(names(unnamed_colour))
})

test_that("c40_colors validates colour names", {
  expect_error(c40_colors("invalid_colour"))
  expect_error(c40_colors("not_a_colour"))
})

test_that("c40_colors accepts numeric indices", {
  expect_equal(c40_colors(1), c40_colors("yellow"))
  expect_equal(c40_colors(2), c40_colors("blue"))
})

# Tests for c40_palettes (new correct spelling)
test_that("c40_palettes returns a function", {
  pal <- c40_palettes("qualitative")
  expect_type(pal, "closure")
})

test_that("c40_palettes works with all palette names", {
  expect_type(c40_palettes("qualitative"), "closure")
  expect_type(c40_palettes("sequential"), "closure")
  expect_type(c40_palettes("dicotomic"), "closure")
  expect_type(c40_palettes("divergent"), "closure")
})

test_that("c40_palettes reverse option works", {
  pal_normal <- c40_palettes("qualitative", reverse = FALSE)
  pal_reversed <- c40_palettes("qualitative", reverse = TRUE)

  # Generate colours and check they are different
  colours_normal <- pal_normal(3)
  colours_reversed <- pal_reversed(3)

  expect_false(identical(colours_normal, colours_reversed))
})

test_that("c40_palettes errors on invalid palette name", {
  expect_error(c40_palettes("invalid_palette"))
})

test_that("c40_palettes generates correct number of colours", {
  pal <- c40_palettes("qualitative")
  expect_length(pal(5), 5)
  expect_length(pal(10), 10)
})

# Tests for deprecated c40_pallets
test_that("c40_pallets shows deprecation warning", {
  expect_warning(
    c40_pallets("qualitative"),
    "c40_pallets\\(\\) is deprecated"
  )
})

test_that("c40_pallets still works despite deprecation", {
  pal <- suppressWarnings(c40_pallets("qualitative"))
  expect_type(pal, "closure")
  expect_length(pal(5), 5)
})

test_that("scale_color_c40 returns a ggplot2 scale", {
 scale <- scale_color_c40()
 expect_s3_class(scale, "Scale")
})

test_that("scale_fill_c40 returns a ggplot2 scale", {
 scale <- scale_fill_c40()
 expect_s3_class(scale, "Scale")
})

test_that("scale functions accept palette argument", {
 expect_s3_class(scale_color_c40(palette = "sequential"), "Scale")
 expect_s3_class(scale_fill_c40(palette = "divergent"), "Scale")
})

test_that("scale functions accept discrete argument", {
 expect_s3_class(scale_color_c40(discrete = TRUE), "Scale")
 expect_s3_class(scale_color_c40(discrete = FALSE), "Scale")
 expect_s3_class(scale_fill_c40(discrete = TRUE), "Scale")
 expect_s3_class(scale_fill_c40(discrete = FALSE), "Scale")
})
