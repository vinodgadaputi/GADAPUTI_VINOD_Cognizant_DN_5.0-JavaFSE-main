// Concrete Factory for Word
public class WordDocumentFactory extends DocumentFactory {

    @Override
    public Document createDocument() {
        System.out.println("WordDocumentFactory: Creating Word Document");
        return new WordDocument();
    }
}
