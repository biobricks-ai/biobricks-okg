( echo -e "s\tp\to"; perl -pe '$_ = join qq{\t}, split(" ", $_, 3)' < knowledge-graph.nt ) | tee knowledge-graph.nt.csv | vd
