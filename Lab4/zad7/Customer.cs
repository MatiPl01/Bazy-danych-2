using System.ComponentModel.DataAnnotations.Schema;

namespace MateuszLopacinskiEFProducts
{
  [Table("Customers")]
  internal class Customer : Company
  {
    public int CompanyID { get; set; }
    public int Discount { get; set; } // In %

    public override string ToString()
    {
      return $"{base.ToString()} (klient)";
    }
  }
}
