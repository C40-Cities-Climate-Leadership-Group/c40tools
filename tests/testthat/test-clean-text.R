# Tests for clean_text function

test_that("clean_text removes lowercase accents from vowels", {
 expect_equal(clean_text("caf\u00e9"), "cafe")
 expect_equal(clean_text("na\u00efve"), "naive")
 expect_equal(clean_text("r\u00e9sum\u00e9"), "resume")
})

test_that("clean_text removes uppercase accents from vowels", {
 expect_equal(clean_text("\u00c9COLE"), "ECOLE")
 expect_equal(clean_text("\u00c1FRICA"), "AFRICA")
})

test_that("clean_text handles common city names", {
 # São Paulo
 expect_equal(clean_text("S\u00e3o Paulo"), "Sao Paulo")
 # México
 expect_equal(clean_text("M\u00e9xico"), "Mexico")
 # Zürich
 expect_equal(clean_text("Z\u00fcrich"), "Zurich")
 # Malmö
 expect_equal(clean_text("Malm\u00f6"), "Malmo")
 # Bogotá
 expect_equal(clean_text("Bogot\u00e1"), "Bogota")
})

test_that("clean_text preserves text without accents", {
 expect_equal(clean_text("London"), "London")
 expect_equal(clean_text("New York"), "New York")
 expect_equal(clean_text("Tokyo"), "Tokyo")
})

test_that("clean_text handles empty strings", {
 expect_equal(clean_text(""), "")
})

test_that("clean_text handles vectors", {
 input <- c("S\u00e3o Paulo", "M\u00e9xico", "London")
 expected <- c("Sao Paulo", "Mexico", "London")
 expect_equal(clean_text(input), expected)
})

test_that("clean_text handles mixed case with accents", {
 expect_equal(clean_text("\u00e1\u00c1"), "aA")
 expect_equal(clean_text("\u00e9\u00c9"), "eE")
})

test_that("clean_text handles multiple accents in same word", {
 # café -> cafe (one accent)
 expect_equal(clean_text("caf\u00e9"), "cafe")
 # résumé -> resume (two accents)
 expect_equal(clean_text("r\u00e9sum\u00e9"), "resume")
})
