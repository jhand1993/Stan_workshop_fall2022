// Similar to lin_regress.stan, but we are centering the input data!

data {
    int N_data;
    vector[N_data] x;
    vector[N_data] y;
}

transformed data {
    // variables here are also global
    real mu_x;
    real sigma_x;
    real mu_y;
    real sigma_y;
    vector[N_data] x_cent;
    vector[N_data] y_cent;

    // We are centering our predictors and dependent samples:
    mu_x = mean(x);
    sigma_x = sd(x);
    mu_y = mean(y);
    sigma_y = sd(y);
    x_cent = (x - mu_x) / sigma_x;
    y_cent = (y - mu_y) / sigma_y;

}

parameters {
    // Slope and intercept for our basis linear regression mode AFTER centering data:
    // y_cent = m_cent * x_cent + b_cent + e
    real m_cent;
    real b_cent;
    // Error 'e' is modeled as drawn from a normal distibution with scale sigma:
    real<lower=0.> sigma_cent;
}

model {
    // This i
    y_cent ~ normal(m_cent * x_cent + b_cent, sigma_cent); 
    sigma_cent ~ gamma(2., 2.); // weakly-informative prior apart from placing no mass where sigma<=0.
}

generated quantities {
    // These quantities are appened after each sample to the output fit
    real m;
    real b;
    real sigma;

    # transformed centered parameters back to our starting space:
    m = m_cent * sigma_y / sigma_x;
    b = b_cent * sigma_y + mu_y - m * mu_x;
    sigma = sigma_cent * sigma_y;
}