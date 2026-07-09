// Concrete Factory for Excel
public class ExcelDocumentFactory extends DocumentFactory {

    @Override
    public Document createDocument() {
        System.out.println("ExcelDocumentFactory: Creating Excel Document");
        return new ExcelDocument();
    }
}
