# Best fuzzy match for -v query=... among the names in the file, which must be
# passed TWICE on the command line:  awk -v query=X -v min=30 -f fuzzy.awk F F
# Anything below -v min=... (percent) is ignored; no output if nothing qualifies.
# Output: "<score> <name>" (score is an integer 0-100).
#
# Similarity = 100 * (1 - distance / max_length), distance = Damerau-Levenshtein
# (OSA variant: insert, delete, replace, swap of adjacent letters).
#
# Speed: pass 1 scores only names that start or end like the query, which finds
# a strong candidate quickly. Pass 2 scans everything, skipping names by length
# and by letter counts (a cheap lower bound on the distance) before running the
# full distance, which itself gives up early once a name cannot beat the best.

# qa[1..lq] = query chars, na[1..ln] = name chars (globals)
function osa(ln, limit,    i, j, cost, m, t, rmin, pmin, prev2, prev, cur) {
    for (j = 0; j <= ln; j++) prev[j] = j
    pmin = 0
    for (i = 1; i <= lq; i++) {
        cur[0] = i; rmin = i
        for (j = 1; j <= ln; j++) {
            cost = (qa[i] == na[j]) ? 0 : 1
            m = prev[j] + 1
            t = cur[j-1] + 1;        if (t < m) m = t
            t = prev[j-1] + cost;    if (t < m) m = t
            if (i > 1 && j > 1 && qa[i] == na[j-1] && qa[i-1] == na[j]) {
                t = prev2[j-2] + 1;  if (t < m) m = t
            }
            cur[j] = m
            if (m < rmin) rmin = m
        }
        if (rmin > limit && pmin > limit) return limit + 1   # cannot get better
        for (j = 0; j <= ln; j++) { prev2[j] = prev[j]; prev[j] = cur[j] }
        pmin = rmin
    }
    return prev[ln]
}

function is_seed(n,    ln) {
    ln = length(n)
    return (substr(n, 1, k) == qhead) || (ln >= k && substr(n, ln - k + 1) == qtail)
}

function consider(name,    n, ln, ml, diff, limit, j, c, common, bag, dist, s) {
    n = tolower(name); ln = length(n)
    ml = (ln > lq) ? ln : lq
    diff = (ln > lq) ? ln - lq : lq - ln
    if (100 * (1 - diff / ml) < bs) return              # length alone rules it out
    limit = int(ml * (100 - bs) / 100 + 0.000001)
    common = 0
    for (j = 1; j <= ln; j++) {
        c = substr(n, j, 1); na[j] = c
        if (used[c] < qcnt[c]) { used[c]++; common++ }
    }
    delete used
    bag = (lq > ln) ? lq - common : ln - common          # letter-count lower bound
    if (bag > limit) return
    dist = osa(ln, limit)
    s = 100 * (1 - dist / ml)
    # ties: more shared letters first (catches swapped letters), then the shorter name
    if (s > bs || (s == bs && (common > bcommon || (common == bcommon && ln < length(best))))) {
        bs = s; best = name; bcommon = common
    }
}

BEGIN {
    q = tolower(query); lq = length(q); best = ""; bs = min - 0.001
    for (i = 1; i <= lq; i++) { qa[i] = substr(q, i, 1); qcnt[qa[i]]++ }
    k = int(lq / 3); if (k < 3) k = 3; if (k > 6) k = 6; if (k > lq) k = lq
    qhead = substr(q, 1, k); qtail = substr(q, lq - k + 1)
}

$0 == "" { next }
FNR == NR { if (is_seed(tolower($0))) consider($0); next }      # pass 1
{ if (!is_seed(tolower($0))) consider($0) }                      # pass 2

END { if (best != "") printf "%d %s\n", bs, best }
