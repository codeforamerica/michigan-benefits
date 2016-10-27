# SSL using Let's Encrypt

[Let's Encrypt](https://letsencrypt.org) provides free SSL. Follow these steps if you want to use it.
If you want to use other SSL for your Citizen Rails-based project, feel free to delete this file, the routes,
and `AcmeChallengesController` and its spec.

## First time setup

* Run `certbot`:

      brew update
      brew install certbot
      sudo certbot certonly --manual

* Enter the domain names:

      example.com, www.example.com, staging.example.com

* Use the output to set config variables:

      heroku config:set ACME_CHALLENGE_REQUEST=v9yjW1CUUehw-gi-diMW6v1PjrWtbequqKL0HyJwvSA ACME_CHALLENGE_RESPONSE=v9yjW1CUUehw-gi-diMW6v1PjrWtbequqKL0HyJwvSA.cUQEiua49JOgZ3Rg1Zzxncu1R1D3ByJuncYlFOVrui4

* I got a "nonce" error; trying again worked.

* Successful output will say something like:

      Congratulations! Your certificate and chain have been saved at
      /etc/letsencrypt/live/example.com/fullchain.pem. Your
      cert will expire on 2016-11-15. To obtain a new or tweaked version
      of this certificate in the future, simply run certbot again. To
      non-interactively renew *all* of your certificates, run "certbot
      renew"

* Backed up the certificate and chain in 1Password

* Set up heroku:

      heroku labs:enable http-sni -a example-app
      heroku plugins:install heroku-certs
      sudo heroku certs:add /etc/letsencrypt/live/example.com/fullchain.pem /etc/letsencrypt/live/example.com/privkey.pem
