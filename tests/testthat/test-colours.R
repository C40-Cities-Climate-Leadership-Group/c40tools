# Tests for C40 colour functions

test_that("c40_colors returns correct hex values for named colours", {
 expect_equal(c40_colors("green"), "#03c245")
 expect_equal(c40_colors("blue"), "#23BCED")
 expect_equal(c40_colors("yellow"), "#fed939")
 expect_equal(c40_colors("violet"), "#8d77c8")
 expect_equal(c40_colors("red"), "#ff614a")
 expect_equal(c40_colors("dark_red"), "#d4444d")
})

test_that("c40_colors returns all colours when called without arguments", {
 all_colours <- c40_colors()
 expect_length(all_colours, 6)
 expect_type(all_colours, "character")
})

test_that("c40_colors returns named vector when name = TRUE", {
 named_colour <- c40_colors("green", name = TRUE)
 expect_named(named_colour, "green")
 expect_equal(unname(named_colour), "#03c245")
})

test_that("c40_colors returns unnamed vector when name = FALSE", {
 unnamed_colour <- c40_colors("green", name = FALSE)
 expect_null(names(unnamed_colour))
})

test_that("c40_colors validates colour names", {
 expect_error(c40_colors("invalid_colour"))
 expect_error(c40_colors("purple"))
})

test_that("c40_colors accepts numeric indices", {
 expect_equal(c40_colors(1), c40_colors("green"))
 expect_equal(c40_colors(2), c40_colors("blue"))
})

test_that("c40_pallets returns a function", {
 pal <- c40_pallets("qualitative")
 expect_type(pal, "closure")
})

test_that("c40_pallets works with all palette names", {
 expect_type(c40_pallets("qualitative"), "closure")
 expect_type(c40_pallets("sequential"), "closure")
 expect_type(c40_pallets("dicotomic"), "closure")
 expect_type(c40_pallets("divergent"), "closure")
})

test_that("c40_pallets reverse option works", {
 pal_normal <- c40_pallets("qualitative", reverse = FALSE)
 pal_reversed <- c40_pallets("qualitative", reverse = TRUE)

 # Generate colours and check they are different
 colours_normal <- pal_normal(3)
 colours_reversed <- pal_reversed(3)

 expect_false(identical(colours_normal, colours_reversed))
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
