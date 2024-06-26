% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scale_color_c40.R
\name{scale_color_c40}
\alias{scale_color_c40}
\title{C40 border color scale}
\usage{
scale_color_c40(palette = "qualitative", discrete = TRUE, reverse = FALSE, ...)
}
\arguments{
\item{palette}{Pallet name from `c40_pallets()`}

\item{discrete}{*TRUE* for discrete variables}

\item{reverse}{*TRUE* returns inverted colors}

\item{...}{Aditional arguments for discrete_scale() or
scale_color_gradientn()}
}
\description{
C40 border color scale
}
\examples{
library(ggplot2)
ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
geom_point(size = 4) +
scale_color_c40()
}
