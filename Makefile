all:
	rm -f langage.exe langage.lex.cpp langage.bison.cpp langage.bison.hpp
	bison -d langage.y -o langage.bison.cpp
	flex -o langage.lex.cpp langage.l
	g++ -w langage.lex.cpp langage.bison.cpp -o langage
	./langage.exe ./test.lpm