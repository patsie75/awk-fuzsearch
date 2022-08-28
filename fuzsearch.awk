#!/usr/bin/awk -f

function min(a, b) { return (a<=b) ? a : b }
function max(a, b) { return (a>=b) ? a : b }
function min3(a, b, c) { return (a<b)&&(a<=c) ? a : ((b<=a)&&(b<=c)) ? b : c }
function max3(a, b, c) { return (a>b)&&(a>=c) ? a : ((b>=a)&&(b>=c)) ? b : c }
function min4(a, b, c, d) { return (a<=b)&&(a<=c)&&(a<=d) ? a : ((b<=a)&&(b<=c)&&(b<=d)) ? b : ((c<=a)&&(c<=b)&&(c<=d)) ? c : d }
function max4(a, b, c, d) { return (a>=b)&&(a>=c)&&(a>=d) ? a : ((b>=a)&&(b>=c)&&(b>=d)) ? b : ((c>=a)&&(c>=b)&&(c>=d)) ? c : d }

function printDistances(d, m,n,    i,j) {
  for (i=0; i<=m; i++) {
    for (j=0; j<=n; j++)
      printf("[%4.1f]", d[i,j])
    printf("\n")
  }
  printf("\n")
}

function levDistance(token1, token2,    d, a,b, m,n, i,j, delCost, insCost, subCost) {
  a = ENVIRON["IGNORECASE"] ? tolower(token1) : token1
  b = ENVIRON["IGNORECASE"] ? tolower(token2) : token2

  m = length(a)
  n = length(b)

  # initialize matrix
  for (i=0; i<=m; i++)
    d[i,0] = i

  for (j=0; j<=n; j++)
    d[0,j] = j

  for (j=1; j<=n; j++) {
    for (i=1; i<=m; i++) {
      delCost = d[i-1,j] + 1
      insCost = d[i,j-1] + 1
      subCost = d[i-1,j-1] + (substr(a,i,1) != substr(b,j,1))

      d[i,j] = min3(delCost, insCost, subCost)
    }
  }

  #printDistances(d, m,n)

  # return the (inverse) ratio of the distance divided by the maximum length of the tokens
  # results in a value between 0 and 100
  return 100 - (d[m,n] / max(m,n)) * 100
}

function DamLevDistance(token1, token2,    a,b, m,n, i,j, k,l, d, da,db, maxdist, delCost, insCost, subCost, transCost) {
  a = ENVIRON["IGNORECASE"] ? tolower(token1) : token1
  b = ENVIRON["IGNORECASE"] ? tolower(token2) : token2

  m = length(a)
  n = length(b)

  for (i=0; i<256; i++)
    da[i] = 0

  maxdist = m + n

  d[-1,-1] = maxdist

  for (i=0; i<=m; i++) {
    d[i,-1] = maxdist
    d[i,0] = i
  }

  for (j=0; j<=n; j++) {
    d[-1,j] = maxdist
    d[0,j] = j
  }

  for (j=1; j<=n; j++) {
    db = 0
    for (i=1; i<=m; i++) {
      k = da[substr(b,j,1)]
      l = db

      delCost = d[i-1,j] + 1
      insCost = d[i,j-1] + 1

      if (substr(a,i,1) == substr(b,j,1)) {
        subCost = d[i-1,j-1] + 0
        db = j
      } else {
        subCost = d[i-1,j-1] + 1
      }

      transCost = d[k-1, l-1] + (i-k-1) + 1 + (j-l-1)
      d[i,j] = min4(delCost, insCost, subCost, transCost)

      da[substr(a,i,1)] = i
    }
  }

#  printDistances(d, m,n)
  return 100 - (d[m,n] / max(m,n)) * 100
}

function OSAdistance(token1, token2,    a,b, m,n, i,j, d, chra,chrb, preva,prevb, cost, del,ins,subs) {
  a = ENVIRON["IGNORECASE"] ? tolower(token1) : token1
  b = ENVIRON["IGNORECASE"] ? tolower(token2) : token2

  m = length(a)
  n = length(b)

  for (i=0; i<=m; i++)
    d[i, 0] = i

  for (j=0; j<=n; j++)
    d[0, j] = j

  for (i=1; i<=m; i++) {
    preva = chra
    chra = substr(a, i, 1)
    for (j=1; j<=n; j++) {
      prevb = chrb
      chrb = substr(b, j, 1)

      delCost = d[i-1,j] + 1
      insCost = d[i,j-1] + 1
      subCost = d[i-1,j-1] + (chra != chrb)

      d[i,j] = min3(delCost, insCost, subCost)

      if ( (i>1) && (j>1) )
        if ( (chra == prevb) && (preva == chrb) )
          d[i,j] = min(d[i,j], d[i-2,j-2] + 1)
    }
  }

#  printDistances(d, m,n)
  return 100 - (d[m,n] / max(m,n)) * 100
}

