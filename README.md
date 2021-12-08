# LPM
Langage de programmation Moliere.

## Fonctionnement :  

- ### Présentation :
    Le Langage de Programmation Molière est un langage qui se veut fidèle à la langue française.  
    De fait, pour l'utiliser, l'utilisateur devra respecter ses usages détaillés ci-dessous :  
    \- Nombres : Le compilateur refusera tout nombre à virgule si le point est employé à l'insu de la virgule elle-même. Ex : 3,14 fonctionne, 3.14 est refusé.  
    \- Instructions : Le compilateur exigera qu'une instruction, à l'instar d'une phrase, démarre par une majuscule et se termine par un point.  
    \- Structuration : Tout comme on peut retrouver en C une fonction "main()", LPM vous demandera de préciser  votre fonction principale :   
    `Fonction principale :`  
    ...  
    `Fin.`  
    De la même manière, les fonctions annexes seront déclarables, avec un nom arbitraire, soit  au dessus, soit au dessous de la fonction principale. 
    
- ### Fonctionnalités :  
    Quelques fonctionnalités propres au LPM :  
    \- Selon l'instruction employée par l'utilisateur, plusieurs syntaxes peuvent être empoyables.  
    (Voir notamment : Variables -> Déclaration)
## Possibilités :

- ### Commentaires :
    Le caractère décrétant un début de commentaire est : °   
    Le raccourci associé est : Maj+')' .  
    Il permet à l'utilisateur de terminer sa ligne de code actuelle par des commentaires.

- ### Variables :
    Type :  
    Le Langage de Programmation Molière a pour variables des nombres, qu'importe leurs formes.    

    Déclaration :  
    La syntaxe est telle que suit :   
    \- `Nouvelle variable sensVie valant 42.`  
    \- `Nouvelle variable vitLum qui vaut 3e8.`  
    \- `Nouvelle variable pi valant 3,14159265.`  
      
    Modification :  
    La syntaxe est telle que suit :  
    \- `Assigner à myFirstVar la valeur 1.`  
    \- `Donner à mySecondVar la valeur de myFirstVar.`  
    \- `Assigner à myThirdVar la valeur mySecondVar + 1.`  
      
- ### Comparaisons :
    Pour vérifier une supériorité stricte : `... (est) supérieur à ... `  
    Pour vérifier une supériorité ou égalité : `... (est) supérieur ou égal à ... `  
        Pour vérifier une infériorité stricte : `... (est) inférieur à ...  `  
    Pour vérifier une infériorité ou égalité : `... (est) inférieur ou égal à ...  `  
    Pour vérifier une égalité : `... (est) égal à ...  ou  ... vaut ...  `  
    Pour vérifier une différence : `... (est) différent de ...  `  

- ### Incrémentations et décrémentations :
    Sont comprises et gérées les posts ainsi que les pré incrémentations et décrémentations :  

    Post.., qui s'appliquent donc avant l'instruction en cours :  

    \- Post-incrémentation : `++myVar.`  

    \- Post-décrémentation : `--myVar. ` 
      
    Pré.., qui s'appliquent après l'instruction en cours :

    \- Pré-incrémentation : `myVar++.`  

    \- Pré-décrémentation : `myVar--.`  
      
- ### Structures de contrôle :
    \- Instruction "Si" :    

    `Si [opérande 1] est égal à [opérande 2] :`    
    ...  
    `Sinon :`  
    ...  
    `Fin.`  
      
    \- Boucle "for" :    

    `Pour [élément (déclarable)], tant que [condition], [élément]++ (, faire) :`  
    /!\ Si l'on déclare une variable i, "nouvelle variable" ne prend pas de majuscule.  
    ...  
    `Fin.`  
      
    \- Boucle "while" :  
      
    `Tant que [condition](, faire) :`  
    ...   
    `Fin.`  
      
    \- Boucle "do_while" :  
      
    `Effectuer puis répéter tant que [condition] :`   
    ...  
    `Fin.`    
      
    \- Ternaire :  
    Quelques exemples avec variations :  

    `myVar est inférieur à 10 ? Si oui : Ecrire myVar, Si non : Ecrire "Non".`  
    `myVar supérieur à 10 ? Si oui : Ecrire myVar, si non, faire : Ecrire "Non".`  
    `myVar est différent de 10 ? Si oui, faire : Ecrire myVar, Sinon : Ecrire "Non".`  
    èmyVar vaut 10 ? Si oui : Ecrire myVar, sinon, faire : Ecrire "Non".`  

      
- ### Affichage d'éléments :  
    Afficher / Ecrire / Affichage de ...    
      
    Voici quelques exemples :  
    `Ecrire "Bonjour le Monde !".`  
    `Afficher myVar.`  
    `Affichage de "Vous avez {varAge} ans, et avez {varAnimaux} animaux de compagnie".`
      
- ### Lecture d'éléments :   
    `Demander myVar.`  
      
- ### Appel de fonctions :  
    LPM, à ce jour, ne traite que les fonctions sans arguments :  
    `Appeller maFunc.`  
    
## Coloration Synthaxique :

Pour avoir accés à notre coloration synthaxique sur l'IDE "Sublime Text", il vous suffit de suivre les instructions suivantes :
- Ouvrez l'emplacement du dossier de Sublime Text puis le dossier Packages.
- Créez-y un dossier appelé "User" par exemple.
- Ouvrez ce dossier et insérez-y les deux fichiers suivants : "test.sublime-color-scheme" et "test.sublime-syntax"
- Vous avez maintenant accés à la coloration synthaxique spécialement conçue pour le langage de programmation Molière
