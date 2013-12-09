# Intro

This is a reference implementation of a basic SAML SP.  It intends to connect with an SAML IdP in order to do login and exchange standard User info.

# Terms

1. SAML - Security Assertion Markup Lanugage
    1. It is simply a way for a Service Provider to make an assertion that the IdP will verify and respond to.
    1. "Is the user signed" is simply the Single Sign-on assertion, but it is not the only one available.
1. IdP - Identity Provider
    1. A known and trusted entity where a Service Provider can send assertion to be verified (or rejected)
1. Service Provider
    1. A known and trusted entity that sends assertions
    
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

# Session Note

This app does not store session.  This is on purpose.