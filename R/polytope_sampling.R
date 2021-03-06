# Here is the script where bilateral data will be Bayesian-processed. This is
# where we call JAGS, where we sample into a polytope and where our custom C++
# JAGS module is used.

#' Get path to jags files used within bimark
#'
#' Bimark uses internal jags files. Use this function to retrieve their location
#' on your system.
#'
#' @param name string the name of the model
#'
#' @return a path to the correspindong jags file
#'
#' @examples
#' GetBayesianModel('test')
#'
#' @export

GetBayesianModel <- function(name) { # {{{
  filename <- paste0(name, '.jags')
  jagsFile <- system.file('jags', filename, package='bimark')
  if (!file.exists(jagsFile))
    throw(paste("Cannot find", filename, "model file."))
  return(jagsFile)
}
# }}}

#' Run a dummy Bayesian MCMC procedure
#'
#' If this runs well, it means that the whole R + JAGS procedure is okay:
#' model files are found, \code{JAGS} is reachable, \code{rjags} package is here
#' and works fine.
#'
#' The dummy procedure draws N random data from an univariate Gaussian, then
#' estimates the mean and variance of this Gaussian with one MCMC. Estimators
#' are searched with uniform priors within a short range around the actual
#' values.
#'
#' @param N integer, the number of data to draw
#' @param n.iter integer, the number of MCMC iterations
#' @param mu real, dummy mean for the Gaussian
#' @param sigma positive real, dummy standard deviance for the Gaussian
#' @param priors range of uniform priors around mu and sigma: \code{c(lowerMu,
#' upperMu, lowerSigma, upperSigma)}
#'
#' @export

DummyJags <- function(N=1e3, n.iter=1e3, mu=15., sigma=.3, # {{{
                      priors=c(-20., 20., 0., 10.)) {

  # retrieve the dummy model
  jagsFile <- GetBayesianModel('test')

  # JAGS's dnorm do not use sigma but tau -_-
  tau <- 1. / sigma ^ 2
  data <- rnorm(N, mu, sigma)
  jm <- rjags::jags.model(jagsFile,
                          data=list(a=data, N=N, priors=priors), quiet=TRUE)
  mc <- rjags::coda.samples(jm,
                            variable.names=c('mu', 'tau'),
                            n.iter=n.iter,
                            n.chains=1)[[1]] # only one chain
  mus <- as.numeric(mc[1:n.iter, 'mu'])
  taus <- as.numeric(mc[1:n.iter, 'tau'])
  sigmas <- 1 / sqrt(taus)
  print(paste0(paste0("mu estimate: ", mean(mus), " vs real: ", mu)))
  print(paste0(paste0("sigma estimate: ", mean(sigmas), " vs real: ", sigma)))
  par(mfrow=c(2, 1))
  plot(mus, type='l')
  plot(taus, type='l')

  print("Okay, everything went well.")

}
# }}}

#' Estimate latent counts with bayesian sampling inside the polytope
#'
#' For now, it is just a sandbox to make JAGS work again from this repo. Start
#' with naive sampling algorithm where we sample inside the bounding box and
#' reject points outside of the polytope.
#'
#' @param model a BimarkModel object
#' @param method string the jags model to use, for now 'test' is the only one
#' available
#'
#' @return an updated BimarkModel object with the estimators, the chains traces
#' and their properties.
#'
#' @export

EstimateLatentCounts <- function(model, method='test') { # {{{

  return(model)

}
# }}}

