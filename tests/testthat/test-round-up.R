# Tests for round_up function

test_that("round_up rounds positive numbers up", {
 expect_equal(round_up(1.1, 0), 2)
 expect_equal(round_up(1.9, 0), 2)
 expect_equal(round_up(1.01, 1), 1.1)
 expect_equal(round_up(1.11, 1), 1.2)
})

test_that("round_up rounds negative numbers away from zero", {
 expect_equal(round_up(-1.1, 0), -2)
 expect_equal(round_up(-1.9, 0), -2)
 expect_equal(round_up(-1.01, 1), -1.1)
 expect_equal(round_up(-1.11, 1), -1.2)
})

test_that("round_up handles exact values", {
 expect_equal(round_up(1.0, 0), 1)
 expect_equal(round_up(1.0, 1), 1.0)
 expect_equal(round_up(-1.0, 0), -1)
})
test_that("round_up handles different decimal places", {
 expect_equal(round_up(1.234, 0), 2)
 expect_equal(round_up(1.234, 1), 1.3)
 expect_equal(round_up(1.234, 2), 1.24)
 expect_equal(round_up(1.234, 3), 1.234)
})

test_that("round_up is vectorised", {
 input <- c(1.11, 2.22, 3.33)
 expected <- c(1.2, 2.3, 3.4)
 expect_equal(round_up(input, 1), expected)
})

test_that("round_up handles mixed positive and negative values", {
 input <- c(1.35, -1.357, 2.363699)
 result <- round_up(input, 2)
 expect_equal(result[1], 1.35)
 expect_equal(result[2], -1.36)
 expect_equal(result[3], 2.37)
})

test_that("round_up default decimal_places is 1", {
 expect_equal(round_up(1.23), round_up(1.23, 1))
})

test_that("round_up handles zero", {
 expect_equal(round_up(0, 0), 0)
 expect_equal(round_up(0, 1), 0)
})

test_that("round_up handles very small numbers", {
 expect_equal(round_up(0.001, 2), 0.01)
 expect_equal(round_up(0.001, 3), 0.001)
})
