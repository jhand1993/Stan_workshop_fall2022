// Largely derived from the following: https://mc-stan.org/docs/stan-users-guide/linear-regression.html

data {
    // variables defined in this scope are global!
    int N_data;
    vector[N_data] x;
    vector[N_data] y;
}

parameters {
    // variables defined in this scope are global!
    // Slope and intercept for our basis linear regression mode:
    // y = m * x + b + e
    real m;
    real b;
    // Error `e' is modeled as drawn from a normal distibution with scale sigma:
    real<lower=0.> sigma;
}

model {
    // This i
    y ~ normal(m * x + b, sigma); 
    sigma ~ gamma(2., 2.); // weakly-informative prior apart from placing no mass on sigma=0.
}