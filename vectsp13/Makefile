.PHONY: prel

all: prel
	verifier -l text/vectsp13

prel:
	miz2prel ../fvsum_1/text/fvsum_1.miz

clean:
	find text ! -name '*.miz' -type f -exec rm -f {} +