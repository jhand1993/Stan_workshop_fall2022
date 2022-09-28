// Largely derived from the following: https://mc-stan.org/docs/stan-users-guide/linear-regression.html

data {
    // variables defined in this scope are global!
    int N_data;
    vector[N_data] x;
    vector[N_data] y;
    vector[N_data] x_res;
}

transformed data{
    real sigma_x_res;
    sigma_x_res = sd(x_res);
}

parameters {
    // variables defined in this scope are global!
    // Slope and intercept for our basis linear regression mode:
    // y = m * x + b + e
    real m;
    real b;
    // Error scaling parameters:
    real<lower=0.> sigma;
    real<lower=0.> tau;

    vector[N_data] x_true;
}

model {
    y ~ normal(m * x_true + b, sigma); 
    x ~ normal(x_true, tau); // predictor variable likelihood component.
    tau ~ normal(sigma_x_res, sigma_x_res);
    sigma ~ gamma(2., 2.); 
}