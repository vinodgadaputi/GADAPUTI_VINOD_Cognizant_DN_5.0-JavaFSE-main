
// Concrete Factory for PDF
public class PdfDocumentFactory extends DocumentFactory {

    @Override
    public Document createDocument() {
        System.out.println("PdfDocumentFactory: Creating PDF Document");
        return new PdfDocument();
    }
}