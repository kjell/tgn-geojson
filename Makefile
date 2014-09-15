coordinates:
	find data -type f | xargs sed -i '' 's/"coords":/"coordinates":/'

dot-geojson:
	find data -type f -name '*.json' | while read file; do \
		>&2 echo $${file/%.json/.geojson}; \
		mv $$file $${file/%.json/.geojson}; \
	done

pretty:
	find data -type f | while read file; do \
		jq '.' < $$file | sponge $$file; \
	done

index:
	find data -type d | tail -n+2 | while read dir; do \
		if [[ ! -f $$dir/index.geojson && $$(ls $$dir | wc -l) -gt 1 ]]; then \
			>&2 echo $$dir; \
			find $$dir -type f -not -name index.geojson \
			| xargs cat \
			| jq -s '{"type": "FeatureCollection", "features": .}' > $$dir/index.geojson; \
		fi; \
	done; \

indexAll:
	jq '{"type": "FeatureCollection", "features": .features}' data/*/index.geojson > data/index.geojson
