for i in {1..20}; do rake linkedin:scrape_users && break || sleep 15; done
