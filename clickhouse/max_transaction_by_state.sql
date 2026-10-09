SELECT
    state,
    argMaxMerge(winner) AS category
FROM hw2.max_transaction_by_state
GROUP BY state
ORDER BY state;
