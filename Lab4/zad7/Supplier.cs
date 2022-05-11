using System.ComponentModel.DataAnnotations.Schema;

namespace MateuszLopacinskiEFProducts
{
  [Table("Suppliers")]
  internal class Supplier : Company
  {
    public int CompanyID { get; set; }
    public string BankAccountNumber { get; set; } = String.Empty;

    public override string ToString()
    {
      return $"{base.ToString()} (dostawca)";
    }
  }
}
