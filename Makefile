PLUGIN_JSON := plugins/crdant/.claude-plugin/plugin.json
VERSION := $(shell python3 -c "import json; print(json.load(open('$(PLUGIN_JSON)'))['version'])")

.PHONY: version patch minor major release

version:
	@echo $(VERSION)

patch:
	@python3 -c "\
	import json; \
	d = json.load(open('$(PLUGIN_JSON)')); \
	parts = list(map(int, d['version'].split('.'))); \
	parts[2] += 1; \
	d['version'] = '.'.join(map(str, parts)); \
	json.dump(d, open('$(PLUGIN_JSON)', 'w'), indent=2, ensure_ascii=False); \
	print(d['version'])"

minor:
	@python3 -c "\
	import json; \
	d = json.load(open('$(PLUGIN_JSON)')); \
	parts = list(map(int, d['version'].split('.'))); \
	parts[1] += 1; parts[2] = 0; \
	d['version'] = '.'.join(map(str, parts)); \
	json.dump(d, open('$(PLUGIN_JSON)', 'w'), indent=2, ensure_ascii=False); \
	print(d['version'])"

major:
	@python3 -c "\
	import json; \
	d = json.load(open('$(PLUGIN_JSON)')); \
	parts = list(map(int, d['version'].split('.'))); \
	parts[0] += 1; parts[1] = 0; parts[2] = 0; \
	d['version'] = '.'.join(map(str, parts)); \
	json.dump(d, open('$(PLUGIN_JSON)', 'w'), indent=2, ensure_ascii=False); \
	print(d['version'])"

release: patch
