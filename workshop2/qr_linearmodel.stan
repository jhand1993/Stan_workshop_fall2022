// Stan QR Linear model: https://mc-stan.org/docs/stan-users-guide/QR-reparameterization.html
// our linear model will be y = beta1 * x1 + beta2 * x2 + ... + betaK * xK + alpha + e,
// where e is our error term: e ~ N(0, sigma).  QR decomposition on a predictor matrix X 
// transforms the problem to y = theta1 * q1 + theta2 * q2 + ... + thetaK * xK + alpha + e,
// where X = QR, Q is orthogonal, and theta = inverse(R)*beta (theta and beta are vectors). 
data {
    int<lower=0> N; // number of y elements (predictions)
    int<lower=0> K; // number of x components per prediction (covariates or predictors)
    matrix[N, K] X; // predictor matrix (N rows, each row of length K)
    vector[N] y; // predictions
}

transformed data {
    // QR decomposition takes our predictor matrix X and decomposes it into 
    // an orthogonal matrix Q and an upper triangular matrix R: X = QR. 
    matrix[N, K] Q_ast;
    matrix[K, K] R_ast;
    matrix[K, K] inverse_R_ast;

    // It is best (according to the Stan gurus) to use a scaled Q_ast*R_ast decomposition!
    Q_ast = qr_thin_Q(X) * sqrt(N - 1); // qr_thin_Q is a built in function for faster QR decomp
    R_ast = qr_thin_R(X) * inv_sqrt(N - 1); // inv_sqrt() has precalculated derivatives, so is faster than / sqrt(x)
    inverse_R_ast = inverse(R_ast); // inv() -> scalar division, inverse() -> matrix inversion!
}

parameters {
    // We are now working in QR space, so we are working with a theta parameter vector now:
    real alpha; // our intercept
    vector[K] theta; // coefficient vector for Q_ast
    real<lower=0.> sigma; // error scale (noise parameter)
}

model {
    // QR decomposition is useful for multilinear(?) regression where informative priors are unavailable.
    // As such, our model only has an explicit likelihood, and all parameters are drawn form uniform priors. 
    y ~ normal(Q_ast * theta + alpha, sigma); // Q_ast * theta is matrix multiplication mapping theta to y.
}

generated quantities {
    // We can recover X-space coefficients beta using inverse_R_ast:
    vector[K] beta;
    beta = inverse_R_ast * theta; // Again, inverse_R_ast * theta is matrix multiplication!
}