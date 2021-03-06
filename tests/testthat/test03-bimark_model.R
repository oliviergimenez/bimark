context("BimarkModel object")
# Basic tests about object integration. All technical stuff about *values* has
# been done in the other test files.

test_that("object creation works", {
  # Observation type
  expected <- "BimarkModel"
  m <- BimarkObservationModel(example.M)
  expect_is(m, expected)
  # Simulation type
  set.seed(12)
  m <- BimarkSimulationModel()
  actual <- class(m)
  expect_equal(actual, expected)
  })

test_that("object pseudo-encapsulation works", {

  m <- BimarkObservationModel(example.M)

  # # reading (allowed)
  expected <- 3
  # $ operator
  actual <- m$LR
  expect_equal(actual, expected)
  # [ operator
  actual <- m['LR']
  expect_equal(actual, list(LR=expected))
  # [[ operator
  actual <- m[['LR']]
  expect_equal(actual, expected)

  # # writing (not allowed)
  # $<- operator
  expect_output(m$LR <- 82, "denied") # user warned
  actual <- m$LR
  expect_equal(actual, expected) # nothing actually written
  # [<- operator
  expect_output(m['LR'] <- 82, "denied")
  actual <- m['LR']
  expect_equal(actual, list(LR=expected))
  # [[<- operator
  expect_output(m[['LR']] <- 82, "denied")
  actual <- m[['LR']]
  expect_equal(actual, expected)

  # # workaround (as offered in `help(BimarkModelEncapsulation)`)
  # $<- operator
  expected <- 82
  tp <- class(m)
  class(m) <- "HighjackModel"
  expect_silent(m$LR <- 82)
  class(m) <- tp
  actual <- m$LR
  expect_equal(actual, expected)
  # [<- operator
  expected <- list(LR=83)
  tp <- class(m)
  class(m) <- "HighjackModel"
  expect_silent(m['LR'] <- 83)
  class(m) <- tp
  actual <- m['LR']
  expect_equal(actual, expected)
  # [[<- operator
  expected <- 84
  tp <- class(m)
  class(m) <- "HighjackModel"
  expect_silent(m[['LR']] <- 84)
  class(m) <- tp
  actual <- m[['LR']]
  expect_equal(actual, expected)

  })

test_that("One-line degenerated cases do not cause drop=TRUE bugs", {
  set.seed(12) # find a LL = 1
  expect_error(m <- BimarkSimulationModel(N=20, T=5), NA)
  set.seed(10) # and a LR = 1
  expect_error(m <- BimarkSimulationModel(N=20, T=5), NA)
  set.seed(142) # and both
  expect_error(m <- BimarkSimulationModel(N=20, T=5), NA)
  })

test_that("Package works for big values of T", {
  # no more crushing integers ceiling, cf commit 7634825
  set.seed(12)
  m <- BimarkSimulationModel(N=1e3, T=50)
  })

