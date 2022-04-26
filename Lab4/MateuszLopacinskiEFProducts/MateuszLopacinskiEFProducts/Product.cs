using System.ComponentModel.DataAnnotations.Schema;

namespace MateuszLopacinskiEFProducts
{
    internal class Product
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public int UnitsOnStock { get; set; } 
    }
}
