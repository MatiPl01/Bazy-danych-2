using System.ComponentModel.DataAnnotations;
using System.Text;

namespace MateuszLopacinskiEFProducts
{
    internal class Invoice
    {
        [Key]
        public int InvoiceNumber { get; set; }
        public int Quantity { get; set; }

        public ICollection<Product> Products { get; set; } = new List<Product>();

        public override string ToString()
        {
            StringBuilder sn = new StringBuilder($"Invoice {InvoiceNumber}:");
            foreach (Product product in Products)
            {
                sn.Append($"\t- {product}");
            }
            return sn.ToString();
        }
    }
}
