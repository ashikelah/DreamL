# SER502-Spring2022-Team20
**Team 20**  
Ashik E.  
Janardhan R.  
Maaz A.  
Michael M.  
Shantanu G.  

**Background**  
DReaM language is a procedural language with a syntactic flavors of database procedural language and main stream imperative languages like, C++ and Java. DReaM language uses java to tokenze it's source code. DCG is used to parse the source code and declarative language-prolog is used to interpret and execute.  

**Tools**  
In order to execute DReaM language JDK1.8 or later version is needed. In addition, swipl version 8.4.2 or more is required. These can be checked in the system by passing these commands in the command line window.  
```
~$ java -version
java version "1.8.0_121"
Java(TM) SE Runtime Environment (build 1.8.0_121-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.121-b13, mixed mode)

~$ swipl --version
SWI-Prolog version 8.4.2 for x86_64-linux
```
**Installation**  
1. Download swipl from https://www.swi-prolog.org/build/macos.html if it’s not there already. Make sure swipl command can be executed from a command line, such as displaying it’s version as shown above.  
2. Download java JDK1.8 or later from oracle page, https://www.oracle.com/java  
3. Clone the git repo to your local system.  

**Executing DReam**  
There are two options for executing DReaM.  
       **Option 1:** Using the DReaM IDE - a graphical user interface application that enables to write, save, and open dream programs (DReaM language source files have .dm extension). The tool also has features to compile and execute the code. It presents the result in the output panel of the gui. To open up the IDE use the following command.     
	 ```java -jar dream_ide.jar```   
       **Option 2 :** Command line dream executor is another tool that is used to execute dream program in terminal. The program needs to be supplied with code to compile and execute. The output will be written in the  terminal.   
       ```java -jar dream.jar helloworld.dm```  

The tools are located in ```src``` directory.  
   
NOTE: The jar files internally call ```DReaM_DCG.pl``` and the file must be in the same folder level as them.
    
**Samples programs**  
Sample DReaM programs can be found under ```src/test``` which where used while developing the language and under ```/data``` which contains some real programs.
     
**License**  
MIT
