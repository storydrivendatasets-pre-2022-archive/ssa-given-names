.PHONY: cleanup cleanup_zips  \
		fetch fetch_zips \
		collate \
		foo

DATADIR = ./data
SRCDIR = ./src/data
DIR_COLL = $(DATADIR)/collated
DIR_RAW = $(DATADIR)/raw
DIR_ZIPS = $(DIR_RAW)/zips

F_ZIPS = $(DIR_ZIPS)/nation.zip $(DIR_ZIPS)/state.zip

COMPILED_HEADERS = 'state,sex,year,name,number'


foo:
	@echo "\ntesting newlines\n"


cleanup: cleanup_zips

cleanup_zips:
	rm -rf $(DIR_ZIPS)

cleanup_collate:
	rm -rf $(DIR_COLL)


######################
# Fetching
fetch: fetch_zips

fetch_zips: cleanup_zips $(F_ZIPS)
	@echo 'Fetched zip files!'
	ls -la $(DIR_ZIPS)

$(DIR_ZIPS)/nation.zip:
	mkdir -p $(DIR_ZIPS)
	curl -o $@ https://www.ssa.gov/oact/babynames/names.zip
	@echo "\n"

$(DIR_ZIPS)/state.zip:
	mkdir -p $(DIR_ZIPS)
	curl -o $@ https://www.ssa.gov/oact/babynames/state/namesbystate.zip
	@echo "\n"


###########################
# collate

collate: cleanup_collate $(DIR_COLL)/nation.csv $(DIR_COLL)/state.csv
	@echo 'Compiled state and nation CSVs!'
	wc -l $(DIR_COLL)/*.csv


$(DIR_COLL)/state.csv: $(DIR_ZIPS)/state.zip
	mkdir -p $(DIR_COLL)
	# unzip into an intermediary dir
	unzip -od $(DIR_RAW)/state $<
	# create new file with headers
	echo $(COMPILED_HEADERS) > $@
	find $(DIR_RAW)/state/*.TXT -type f \
	    -exec cat {} \;\
	    >> $@

$(DIR_COLL)/nation.csv: $(DIR_ZIPS)/nation.zip
	mkdir -p $(DIR_COLL)
	# unzip into an intermediary dir
	unzip -od $(DIR_RAW)/nation $<
	# create new file with headers
	echo $(COMPILED_HEADERS) > $@

	find $(DIR_RAW)/nation/*.txt -type f \
	    -exec $(SRCDIR)/prepend_nation_year.py {} \;\
	    >> $@















