import SwiftUI
import Charts

struct PDFTry: View {
    
    @State var vendas2027: String = "0"
    @State var vendas2028: String = "1.2"
    @State var vendas2029: String = "3.4"
    @State var vendas2030: String = "6"
    
    var chartView: some View {
        
        Chart {
            BarMark(x: .value("Ano", "2027"), y: .value("Vendas", Double(vendas2027) ?? 0))
                .foregroundStyle(.red).opacity(0.5)
            BarMark(x: .value("Ano", "2028"), y: .value("Vendas", Double(vendas2028) ?? 0))
                .foregroundStyle(.blue).opacity(0.5)
            BarMark(x: .value("Ano", "2029"), y: .value("Vendas", Double(vendas2029) ?? 0))
                .foregroundStyle(.purple).opacity(0.5)
            BarMark(x: .value("Ano", "2030"), y: .value("Vendas", Double(vendas2030) ?? 0))
                .foregroundStyle(.gray).opacity(0.5)
            
            
        }
        .frame(width: 350, height: 400)
        .padding()
        .background(Color.white)
        
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                chartView
                
                VStack(spacing: 15) {
                    Group {
                        TextField("Vendas 2027", text: $vendas2027)
                        TextField("Vendas 2028", text: $vendas2028)
                        TextField("Vendas 2029", text: $vendas2029)
                        TextField("Vendas 2030", text: $vendas2030)
                    }
                    .frame(width: 300, height: 44)
                    .textFieldStyle(.roundedBorder)
                    
                }
                
                ShareLink(item: generatePDF()) {
                    Label("Exportar PDF", systemImage: "square.and.arrow.down")
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
    

    @MainActor
    func generatePDF() -> URL {
        let renderer = ImageRenderer(content: chartView)
        
        let url = URL.documentsDirectory.appending(path: "GraficoVendas.pdf")
        
        renderer.render { size, context in
            var box = CGRect(origin: .zero, size: size)
            
            guard let pdfContext = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            
            pdfContext.beginPDFPage(nil)
            context(pdfContext)
            pdfContext.endPDFPage()
            pdfContext.closePDF()
        }
        
        return url
    }
}

#Preview {
    ContentView(vendas2027: "200", vendas2028: "302", vendas2029: "120", vendas2030: "90")
}
