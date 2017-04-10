

data { 
  int<lower=0> N; //n observations
  vector[N] y; // outcomes
  int<lower=0> P; //rank of predictors
  matrix[N,P] x; // all time invariant--includes intercept
  } 

parameters{
  vector[P] beta; // estimate of effects
  real<lower=0> sig; //error variance; BDA3 388 - uniform gelman 2006; stan manual 66
}

model{

  //prior
  #pp. 294-295 BDA3
  beta ~ normal(0,5);
  sig ~ cauchy(0,5);

  //likelihood
  y ~ normal(x*beta,sig);
}

