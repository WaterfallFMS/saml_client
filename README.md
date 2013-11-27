# Intro

This is a reference implmentation of a basic Waterfall Rails stack.  It intends to connect with an SAML IdP in order to do login and exchange standard User info.

# Terms

1. SAML - Security Assertion Markup Lanugage
    1. It is simply a way for a Service Provider to make an assertion that the IdP will verify and respond to.
    1. "Is the user signed" is simply the Single Sign-on assertion, but it is not the only one available.
1. IdP - Identity Provider
    1. A known and trusted entity where a Service Provider can send assertion to be verified (or rejected)
1. Service Provider
    1. A known and trusted entity that sends assertions
    
# Why not OAuth

SAML is a HTTP based protocol that wraps a directory of users and permissions.  Only part of the protocol is concerns with Single Sign-on.

OAuth, on the otherhand, only aims to solve the Single Sign-on problem and it does so by decentralizing login.

From a Service Provider point of view, the end goal is nearly identical: user come to a site, is redirected to sign-in elsewhere, is redirected back with secure data, the data is cached, and access is granted.  The only difference is where the redirects are made, what and how the data is transfered, and how many hand-offs are made.  But is you understand one you basically understand both.

With OAuth there is usually a paywall which causes users to self-select out of services that they do not use.  In the corporate settings, since there is no user paywall, this is done arbitrarily with roles and permissons.

Therefore, they differ in their approach to user management.  OAuth empowers users to control their information, and which sites have access to what information.  SAML empowser corporate entites (made up of any number of users) to contral their information as well as the information of subordinants (users), and also to grant powers.  SAML does this by wraping the time tested Directory (ActiveDirectory, LDAP) model, with an OAuth like protocol that can be used Cross Domains.


# SAML IdP setup

An IdP is loaded via a set of ENV settings.  See `/scripts/local_ipd_env` for an example.

## Pow

If using pow to serve the Rails app you simply source the required env at the top of the `.powrc` file.

# Usage

```bash
$ cd ~/.pow
$ ln -s path/to/saml_client saml-client
$ open http://saml-client.dev
```

If you are not already logged in then you will be redirected to the IdP to signin.  After signin you will be redirected back and be shown the User meta data that was collected.

All subsequent calls to the app will simply use the already stored session.

## Session logout

With SAML each service provider has their own login session.  When you are redirected to the IdP and login there you get an IdP session.

## IdP logout