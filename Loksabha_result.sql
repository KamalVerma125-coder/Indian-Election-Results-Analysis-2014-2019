show databases;
use kamaldb;
create table result_2014(VID int not null primary key auto_increment,
state varchar(500),
pc_name varchar(500),
candidate varchar(500),
sex varchar(500),
age varchar(500),
category varchar(500),
party varchar(500),
party_symbol varchar(500),
general_votes int,
postal_votes int,
total_votes int,
total_electors int);

show tables;
select * from result_2014;

update result_2014 set State="Telangana" where pc_name in('Adilabad', 'Peddapalle', 'Karimnagar', 'Nizamabad', 'Zahirabad', 'Medak' ,'Malkajgiri', 'Secundrabad', 'Hyderabad',
'CHELVELLA', 'Mahbubnagar', 'Nagarkurnool', 'Nalgonda', 'Bhongir', 'Warangal', 'Mahabubabad', 'Khammam');



create table result_2019(VID int not null primary key auto_increment,
state varchar(500),
pc_name varchar(500),
candidate varchar(500),
sex varchar(500),
age varchar(500),
category varchar(500),
party varchar(500),
party_symbol varchar(500),
general_votes int,
postal_votes int,
total_votes int,
total_electors int);

select * from result_2019;

select distinct state from result_2019;

select distinct  pc_name, state from result_2019 where state='Telangana';

select party, sum(total_votes) from result_2014  group by party order by  sum(total_votes) desc ;

SELECT * FROM result_2014;

/* Bottom 5 Constituencies 2014 */
select pc_name, (sum(total_votes)/min(total_electors)) as voter_turnout_ratio from result_2014 group by pc_name order by voter_turnout_ratio limit 5;

/* Top 5 Constituencies 2014*/
select pc_name, (sum(total_votes)/min(total_electors)) as voter_turnout_ratio from result_2014 group by pc_name order by voter_turnout_ratio desc limit 5;

/* Bottom 5 Constituencies 2019 */
select pc_name, (sum(total_votes)/min(total_electors)) as voter_turnout_ratio from result_2019 group by pc_name order by voter_turnout_ratio limit 5;

/* Top 5 Constituencies 2019*/
select pc_name, (sum(total_votes)/min(total_electors)) as voter_turnout_ratio from result_2019 group by pc_name order by voter_turnout_ratio desc limit 5;

/* Top 5 States 2014*/
select distinct state, (sum(total_votes)/min(total_electors)) as voter_turnout_ratio from result_2014 group by state order by voter_turnout_ratio desc limit 5;

/* Bottom 5 States 2014*/
select distinct state, (sum(total_votes)/min(total_electors)) as voter_turnout_ratio from result_2014 group by state order by voter_turnout_ratio asc limit 5;

/* Top 5 States 2019*/
select distinct state, (sum(total_votes)/min(total_electors)) as voter_turnout_ratio from result_2019 group by state order by voter_turnout_ratio desc limit 5;

/* Bottom 5 States 2019*/
select distinct state, (sum(total_votes)/min(total_electors)) as voter_turnout_ratio from result_2019 group by state order by voter_turnout_ratio asc limit 5;

/*The Consitutencies who elected the same party for two consecutive elections*/
SELECT
    r14.state AS state_2014,
    r14.pc_name AS pc_name_2014,
    r14.candidate AS candidate_2014,
    r14.party AS party_2014,
    r14.party_symbol AS party_symbol_2014,
    r14.general_votes AS general_votes_2014,
    r14.postal_votes AS postal_votes_2014,
    r14.total_votes AS total_votes_2014,
    r14.total_electors AS total_electors_2014,
    r19.candidate AS candidate_2019,
    r19.party AS party_2019,
    r19.party_symbol AS party_symbol_2019,
    r19.general_votes AS general_votes_2019,
    r19.postal_votes AS postal_votes_2019,
    r19.total_votes AS total_votes_2019,
    r19.total_electors AS total_electors_2019,
    -- Calculate the percentage of votes received by the winning party in 2019
    (r19.total_votes / total_votes_2019_per_pc.total_votes_2019) * 100 AS percentage_votes_2019
FROM
    result_2014 r14
LEFT JOIN
    result_2019 r19
ON
    r14.state = r19.state
    AND r14.pc_name = r19.pc_name
    AND r14.party = r19.party
LEFT JOIN (
    -- Subquery to get total votes for each pc_name in 2019
    SELECT
        pc_name,
        SUM(total_votes) AS total_votes_2019
    FROM
        result_2019
    GROUP BY
        pc_name
) total_votes_2019_per_pc
ON
    r19.pc_name = total_votes_2019_per_pc.pc_name
WHERE
    (r14.pc_name, r14.total_votes) IN (
        SELECT
            r14_sub.pc_name,
            MAX(r14_sub.total_votes)
        FROM
            result_2014 r14_sub
        GROUP BY
            r14_sub.pc_name
    )
ORDER BY
    percentage_votes_2019 desc ;

/*The Constituencies have voted for different parties in two elections*/
SELECT
    r14.state AS state_2014,
    r14.pc_name AS pc_name_2014,
    r14.candidate AS candidate_2014,
    r14.party AS party_2014,
    r14.party_symbol AS party_symbol_2014,
    r14.general_votes AS general_votes_2014,
    r14.postal_votes AS postal_votes_2014,
    r14.total_votes AS total_votes_2014,
    r14.total_electors AS total_electors_2014,
    r19.candidate AS candidate_2019,
    r19.party AS party_2019,
    r19.party_symbol AS party_symbol_2019,
    r19.general_votes AS general_votes_2019,
    r19.postal_votes AS postal_votes_2019,
    r19.total_votes AS total_votes_2019,
    r19.total_electors AS total_electors_2019,
    -- Calculate the percentage of votes received by the winning party in 2019
    (r19.total_votes / total_votes_2019_per_pc.total_votes_2019) * 100 AS percentage_votes_2019
FROM
    result_2014 r14
LEFT JOIN
    result_2019 r19
ON
    r14.state = r19.state
    AND r14.pc_name = r19.pc_name
    AND r14.party != r19.party
LEFT JOIN (
    -- Subquery to get total votes for each pc_name in 2019
    SELECT
        pc_name,
        SUM(total_votes) AS total_votes_2019
    FROM
        result_2019
    GROUP BY
        pc_name
) total_votes_2019_per_pc
ON
    r19.pc_name = total_votes_2019_per_pc.pc_name
WHERE
    (r14.pc_name, r14.total_votes) IN (
        SELECT
            r14_sub.pc_name,
            MAX(r14_sub.total_votes)
        FROM
            result_2014 r14_sub
        GROUP BY
            r14_sub.pc_name
    )
ORDER BY
    percentage_votes_2019 desc limit 10;
    
/*Top 5 candidates based on margin difference with runners in 2014 and 2019.*/
    
    WITH mov_calculation AS (
    SELECT
        candidate,
        year,
        (general_votes / total_votes) * 100 AS vote_percentage
    FROM
        (
            SELECT candidate, general_votes, total_votes, 2014 AS year FROM result_2014
            UNION ALL
            SELECT candidate, general_votes, total_votes, 2019 AS year FROM result_2019
        ) AS combined_results
),
mov_2014 AS (
    SELECT
        candidate,
        vote_percentage AS mov_2014
    FROM
        mov_calculation
    WHERE
        year = 2014
),
mov_2019 AS (
    SELECT
        candidate,
        vote_percentage AS mov_2019
    FROM
        mov_calculation
    WHERE
        year = 2019
),
margin_differences AS (
    SELECT
        m2014.candidate,
        COALESCE(m2019.mov_2019, 0) - m2014.mov_2014 AS margin_difference
    FROM
        mov_2014 m2014
    LEFT JOIN
        mov_2019 m2019
    ON
        m2014.candidate = m2019.candidate
)

SELECT
    candidate,
    margin_difference
FROM
    margin_differences
ORDER BY
    margin_difference DESC
LIMIT 5;

/*% Split of votes of parties between 2014 vs 2019 at national level*/

WITH votes_2014 AS (
    SELECT 
        party,
        SUM(total_votes) AS total_votes_2014
    FROM
        result_2014
    GROUP BY
        party
),
votes_2019 AS (
    SELECT
        party,
        SUM(total_votes) AS total_votes_2019
    FROM
        result_2019
    GROUP BY
        party
),
total_votes AS (
    SELECT '2014' AS year, SUM(total_votes) AS total_votes
    FROM result_2014
    UNION ALL
    SELECT '2019' AS year, SUM(total_votes) AS total_votes
    FROM result_2019
),
total_votes_summary AS (
    SELECT
        MAX(CASE WHEN year = '2014' THEN total_votes END) AS total_votes_2014,
        MAX(CASE WHEN year = '2019' THEN total_votes END) AS total_votes_2019
    FROM
        total_votes
),
percentage_split AS (
    SELECT
        v14.party,
        (v14.total_votes_2014 / t.total_votes_2014) * 100 AS percentage_2014,
        (COALESCE(v19.total_votes_2019, 0) / t.total_votes_2019) * 100 AS percentage_2019
    FROM
        votes_2014 v14
    LEFT JOIN
        votes_2019 v19 ON v14.party = v19.party
    CROSS JOIN
        total_votes_summary t
),
percentage_difference AS (
    SELECT
        party,
        percentage_2014,
        percentage_2019,
        percentage_2019 - percentage_2014 AS percentage_difference
    FROM
        percentage_split
)

SELECT
    party,
    percentage_2014,
    percentage_2019,
    percentage_difference
FROM
    percentage_difference
ORDER BY
    percentage_difference DESC;

/*% Split of votes of parties between 2014 vs 2019 at state level*/

WITH votes_2014 AS (
    SELECT 
        party,
        state,
        SUM(total_votes) AS total_votes_2014
    FROM
        result_2014
    GROUP BY
        party, state
),
votes_2019 AS (
    SELECT
        party,
        state,
        SUM(total_votes) AS total_votes_2019
    FROM
        result_2019
    GROUP BY
        party, state
),
total_votes AS (
    SELECT '2014' AS year, SUM(total_votes) AS total_votes
    FROM result_2014
    UNION ALL
    SELECT '2019' AS year, SUM(total_votes) AS total_votes
    FROM result_2019
),
total_votes_summary AS (
    SELECT
        MAX(CASE WHEN year = '2014' THEN total_votes END) AS total_votes_2014,
        MAX(CASE WHEN year = '2019' THEN total_votes END) AS total_votes_2019
    FROM
        total_votes
),
percentage_split AS (
    SELECT
        v14.party,
        v14.state,
        (v14.total_votes_2014 / t.total_votes_2014) * 100 AS percentage_2014,
        (COALESCE(v19.total_votes_2019, 0) / t.total_votes_2019) * 100 AS percentage_2019
    FROM
        votes_2014 v14
    LEFT JOIN
        votes_2019 v19 ON v14.party = v19.party AND v14.state = v19.state
    CROSS JOIN
        total_votes_summary t
),
percentage_difference AS (
    SELECT
        party,
        state,
        percentage_2014,
        percentage_2019,
        percentage_2019 - percentage_2014 AS percentage_difference
    FROM
        percentage_split
)

SELECT
    party,
    state,
    percentage_2014,
    percentage_2019,
    percentage_difference
FROM
    percentage_difference
ORDER BY
    percentage_difference DESC;

/*List top 5 constituencies for two major national parties where they have gained vote share in 2019 as compared to 2014*/

WITH votes_2014 AS (
    SELECT 
        party,
        state,
        SUM(total_votes) AS total_votes_2014
    FROM
        result_2014
    WHERE
        party IN ('BJP', 'INC')
    GROUP BY
        party, state
),
votes_2019 AS (
    SELECT
        party,
        state,
        SUM(total_votes) AS total_votes_2019
    FROM
        result_2019
    WHERE
        party IN ('BJP', 'INC')
    GROUP BY
        party, state
),
total_votes AS (
    SELECT '2014' AS year, SUM(total_votes) AS total_votes
    FROM result_2014
    UNION ALL
    SELECT '2019' AS year, SUM(total_votes) AS total_votes
    FROM result_2019
),
total_votes_summary AS (
    SELECT
        MAX(CASE WHEN year = '2014' THEN total_votes END) AS total_votes_2014,
        MAX(CASE WHEN year = '2019' THEN total_votes END) AS total_votes_2019
    FROM
        total_votes
),
percentage_split AS (
    SELECT
        v14.party,
        v14.state,
        (v14.total_votes_2014 / t.total_votes_2014) * 100 AS percentage_2014,
        (COALESCE(v19.total_votes_2019, 0) / t.total_votes_2019) * 100 AS percentage_2019
    FROM
        votes_2014 v14
    LEFT JOIN
        votes_2019 v19 ON v14.party = v19.party AND v14.state = v19.state
    CROSS JOIN
        total_votes_summary t
),
percentage_difference AS (
    SELECT
        party,
        state,
        percentage_2014,
        percentage_2019,
        percentage_2019 - percentage_2014 AS percentage_difference
    FROM
        percentage_split
),
ranked_result AS (
    SELECT
        party,
        state,
        percentage_2014,
        percentage_2019,
        percentage_difference,
        ROW_NUMBER() OVER (PARTITION BY party ORDER BY percentage_difference DESC) AS ranke
    FROM
        percentage_difference
)

SELECT
    party,
    state,
    percentage_2014,
    percentage_2019,
    percentage_difference
FROM
    ranked_result
WHERE
    ranke <= 5
ORDER BY
    party,
    ranke;
    
/*List top 5 constituencies for two major national parties where they have lost vote share in 2019 as comapted to 2014*/

WITH votes_2014 AS (
    SELECT 
        party,
        state,
        SUM(total_votes) AS total_votes_2014
    FROM
        result_2014
    WHERE
        party IN ('BJP', 'INC')
    GROUP BY
        party, state
),
votes_2019 AS (
    SELECT
        party,
        state,
        SUM(total_votes) AS total_votes_2019
    FROM
        result_2019
    WHERE
        party IN ('BJP', 'INC')
    GROUP BY
        party, state
),
total_votes AS (
    SELECT '2014' AS year, SUM(total_votes) AS total_votes
    FROM result_2014
    UNION ALL
    SELECT '2019' AS year, SUM(total_votes) AS total_votes
    FROM result_2019
),
total_votes_summary AS (
    SELECT
        MAX(CASE WHEN year = '2014' THEN total_votes END) AS total_votes_2014,
        MAX(CASE WHEN year = '2019' THEN total_votes END) AS total_votes_2019
    FROM
        total_votes
),
percentage_split AS (
    SELECT
        v14.party,
        v14.state,
        (v14.total_votes_2014 / t.total_votes_2014) * 100 AS percentage_2014,
        (COALESCE(v19.total_votes_2019, 0) / t.total_votes_2019) * 100 AS percentage_2019
    FROM
        votes_2014 v14
    LEFT JOIN
        votes_2019 v19 ON v14.party = v19.party AND v14.state = v19.state
    CROSS JOIN
        total_votes_summary t
),
percentage_difference AS (
    SELECT
        party,
        state,
        percentage_2014,
        percentage_2019,
        percentage_2019 - percentage_2014 AS percentage_difference
    FROM
        percentage_split
),
ranked_result AS (
    SELECT
        party,
        state,
        percentage_2014,
        percentage_2019,
        percentage_difference,
        ROW_NUMBER() OVER (PARTITION BY party ORDER BY percentage_difference ASC) AS ranke
    FROM
        percentage_difference
)

SELECT
    party,
    state,
    percentage_2014,
    percentage_2019,
    percentage_difference
FROM
    ranked_result
WHERE
    ranke <= 5
ORDER BY
    party,
    ranke;    

/*Which constituency has voted the most for NOTA*/
select* from result_2014 where party = 'NOTA' order by total_votes desc limit 5;
select* from result_2019 where party = 'NOTA' order by total_votes desc limit 5;

/*Which constituencies have elected candidates whose party has less than 10% vote share at state level in 2019*/

CREATE TABLE temp_state_vote_share AS
SELECT
    state,
    party,
    (SUM(total_votes) / SUM(total_electors)) * 100 AS vote_share
FROM
    result_2019
GROUP BY
    state, party;

select * from temp_state_vote_share;

CREATE TEMPORARY TABLE parties_less_than_10 AS
SELECT
    state,
    party
FROM
    temp_state_vote_share
WHERE
    vote_share < 10;
    
    select * from parties_less_than_10;
    
    CREATE TEMPORARY TABLE elected_candidates AS
SELECT
    r.state,
    r.pc_name,
    r.party AS elected_party
FROM
    result_2019 r
WHERE
    r.total_votes = (
        SELECT MAX(total_votes)
        FROM result_2019 r2
        WHERE r2.pc_name = r.pc_name
        AND r2.state = r.state
    );

SELECT
    ec.state,
    ec.pc_name,
    ec.elected_party
FROM
    elected_candidates ec
JOIN
    parties_less_than_10 p
ON
    ec.elected_party = p.party
    AND ec.state = p.state
ORDER BY
    ec.state,
    ec.pc_name;

