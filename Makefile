.PHONY: prel
all: prel
	mizf text/matroid1

prel:
	miz2prel fvsum_1/text/fvsum_1.miz
	miz2prel vectsp_7/text/vectsp_7.miz
	cd vectsp13 && make prel
	miz2prel vectsp13/text/vectsp13.miz

clean:
	find text ! -name '*.miz' -type f -exec rm -f {} +