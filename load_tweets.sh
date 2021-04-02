files='
test-data.zip
'

for file in $files; do
    # call the load_tweets.py file to load data into pg_normalized
    ./load_tweets.py --db postgresql://postgres:pass@localhost:11202/ --inputs $file
done

for file in $files; do
    # use SQL's COPY command to load data into pg_denormalized
    # postgresql://username:password@host:port/database
    unzip -p $file | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:11201/ -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
done
