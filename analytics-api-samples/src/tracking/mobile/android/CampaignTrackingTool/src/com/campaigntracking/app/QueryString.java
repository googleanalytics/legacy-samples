// Copyright 2011 Google Inc. All Rights Reserved.

package com.campaigntracking.app;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


/**
 * An object representing a query string that would be included with an
 * Android Market destination URL.
 * 
 * @author awales@google.com (Andrew Wales)
 */
public class QueryString {

  private static final String REFERRER_KEY = "referrer";
  private static final String AUTO_TAG_VALUE = "gclid%3DAutoTagTestValue";
  private static final String ID_KEY = "id";

  private String queryString;
  private Map <String, String> parameterMap;

  /**
   * An object representing a query string comprised of parameter-value pairs.
   * Query string is assumed to be not a full URL with query parameters, and not
   * URL encoded.
   * 
   * @param q The raw query string.
   */
  public QueryString (String q) {

    queryString = q;
    // Beginning the query string with '?' is not required. Strip out '?' if
    // user provides it at the beginning of the string.
    if (queryString.startsWith("?")) {
      queryString = queryString.substring(1);
    }
    parameterMap = getParameterMap(queryString);
  }


  /**
   * Method to parse a raw query string into parameter-value pairs and return
   * them in a {@code Map}.
   * 
   * @param q The raw query string to be parsed.
   * @return {@code Map} containing parameter-value pairs.
   */
  public Map <String, String> getParameterMap (String q) {

    // Initialize HashMap to store parameter-value pairs.
    Map<String, String> paramMap = new HashMap<String, String>();

    // Store parameter-value pairs in an array.
    String[] params = queryString.split("&");

    // Split parameter-value pairs and store in a HashMap.
    for (String s : params) {
      String[] ss = s.split("=");
      if (ss.length > 1) {
        paramMap.put(ss[0], ss[1]);
      } else if (ss.length == 1) {
        paramMap.put(ss[0], null);
      }
    }
    return paramMap;
  }


  public void addAutoTag() {

    // If referrer parameter is present and not null, append a Google click id
    // test value to the value, preceded by an encoded '&'. 
    if (hasReferrer(REFERRER_KEY)) {
      String newReferrer = getReferrer(REFERRER_KEY) + "%26" + AUTO_TAG_VALUE;
      addParameter(REFERRER_KEY, newReferrer);
    }
    // Otherwise, add a referrer parameter if it doesn't already exist, and
    // set its value equal to the auto-tagging test value.
    addParameter(REFERRER_KEY, AUTO_TAG_VALUE);
  }


  public boolean hasParameters() {

    if (parameterMap.size() > 0) {
      return true;
    }
    return false;
  }


  public void addParameter(String param, String value) {

      parameterMap.put(param, value);
  }


  public boolean hasId () {

    return parameterMap.containsKey(ID_KEY) &&
        parameterMap.get(ID_KEY) != null;
  }


  public String getId() {

    if (hasId()) {
      return parameterMap.get(ID_KEY);
    }
    return null;
  }


  public boolean hasReferrer(String referrerKey) {

    if (parameterMap.containsKey(referrerKey) &&
        parameterMap.get(referrerKey) != null) {
      return true;
    }
    return false;
  }


  public String getReferrer(String referrerKey) {

    if (hasReferrer(referrerKey)) {
      return parameterMap.get(referrerKey).toString();
    }
    return null;
  }


  public boolean isEncoded(String referrerKey) {

    if (parameterMap.get(referrerKey).toString().contains("%3D")) {
      return true;
    }
    return false;
  }


  public ArrayList <String> getFloatingUtmTags(String [] utmTags) {

    ArrayList <String> floatingTags = new ArrayList <String>();
    for (int x = 0; x < utmTags.length; x++) {
      if (parameterMap.containsKey(utmTags[x])) {
        floatingTags.add(utmTags[x]);
      }
    }
    return floatingTags;
  }


  public String getPackageName(String idKey) {

    if (hasId()) {
      return parameterMap.get(idKey).toString();
    }
    return null;
  }
}

