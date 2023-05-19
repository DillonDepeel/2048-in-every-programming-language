/*

Run this code to generate the list of programming languages used in 2048-in-every-programming-language repository

*/

// find path of repository
string foldersPath = Path.Combine(Directory.GetCurrentDirectory());
int index = foldersPath.IndexOf("ListAllLanguages");
foldersPath = foldersPath.Substring(0, index);

// find files in repository that are of language programs
List<string> filesToSearch = Directory.GetFileSystemEntries(foldersPath).ToList();
string searchKey = "rograms"; // change this search key if alphabet folder names are formatted differently
filesToSearch = filesToSearch.Where(x => x.Contains(searchKey)).ToList();

// get all programming languages that exist in the folders
List<string> languageNames = new();
foreach(string file in filesToSearch)
{
    string[] fileLanguages = Directory.GetFiles(file);
    foreach(string fileLanguage in fileLanguages)
    {
        languageNames.Add(Path.GetFileNameWithoutExtension(fileLanguage).Replace(" 2048", ""));
    }
}

// format the list of programming languages into readme markdown syntax
char[] alphabet = Enumerable.Range('A', 26).Select(x => (char)x).ToArray();
int indexAlphabet = 0;
List<string> readmeListLanguages = new();
foreach(char letter in alphabet)
{
    readmeListLanguages.Add($"## {letter}");
    List<string> sortedLanguageNames = languageNames.Where(x => x.StartsWith(letter)).ToList();
    foreach(var languageName in sortedLanguageNames)
    {
        readmeListLanguages.Add($"* {languageName}");
    }
}

// print the list of programming languages into LanguageList.txt. this can then be copy pasted into README.md 
string readmePath = Path.Combine(foldersPath, "LanguageList.txt");
File.WriteAllLines(readmePath, readmeListLanguages.ToArray());
