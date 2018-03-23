using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GenerateSortieIDs
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 1)
            {
                Console.WriteLine("ERROR - Invalid Arguments - Must be \"Connection String\"");
                Console.ReadLine();
                return;
            }
            MySql.Data.MySqlClient.MySqlConnection _conn = null;
            MySql.Data.MySqlClient.MySqlConnection _updateconn = null;
            MySql.Data.MySqlClient.MySqlDataReader rdr = null;
            Dictionary<string, long> PlayerSorties = new Dictionary<string, long>();
            long auto_gen_sortie_id = 0;
            long rows_processed = 0;

            try
            {
                _conn = new MySql.Data.MySqlClient.MySqlConnection(args[0]);
                _conn.Open();
                _updateconn = new MySql.Data.MySqlClient.MySqlConnection(args[0]);
                _updateconn.Open();
                MySql.Data.MySqlClient.MySqlCommand cmd = new MySql.Data.MySqlClient.MySqlCommand("SELECT id, session_id, ucid, event FROM raw_gameevents_log WHERE ucid IS NOT NULL ORDER BY session_id, ucid;")
                {
                    Connection = _conn,
                    CommandType = System.Data.CommandType.Text
                };
                rdr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(rdr);

                long total_rows = dt.Rows.Count;

                foreach (DataRow dr in dt.Rows)
                {
                    string ucid = dr.Field<string>("ucid");
                    string gevent = dr.Field<string>("event");
                    long id = dr.Field<long>("id");

                    if (ucid != null && dr["ucid"] != DBNull.Value)
                    { 
                        if (!PlayerSorties.ContainsKey(ucid))
                        {
                            auto_gen_sortie_id += 1;
                            PlayerSorties.Add(ucid, auto_gen_sortie_id);
                        }

                        if (gevent == "TAKEOFF")
                        {
                            auto_gen_sortie_id += 1;
                            PlayerSorties[ucid] = auto_gen_sortie_id;
                        }

                        try
                        {
                            MySql.Data.MySqlClient.MySqlCommand updatecmd =
                                new MySql.Data.MySqlClient.MySqlCommand("UPDATE raw_gameevents_log SET sortie_id = @param_sortie_id WHERE id = @param_event_id;");
                            updatecmd.Parameters.AddWithValue("@param_sortie_id", PlayerSorties[ucid]);
                            updatecmd.Parameters.AddWithValue("@param_event_id", id);

                            updatecmd.Connection = _conn;
                            updatecmd.CommandType = System.Data.CommandType.Text;
                            int res = Convert.ToInt32(updatecmd.ExecuteScalar());                      
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Error updating row (id: " + id + ") - " + ex.Message);
                        }               
                    }
                    rows_processed += 1;
                    if (rows_processed % 100 == 0)
                    {
                        Console.WriteLine("Processed Rows " + rows_processed + " of " + total_rows);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error selecting data - " + ex.Message);
            }
            finally
            {
                if (_conn != null)
                    if (_conn.State == System.Data.ConnectionState.Open || _conn.State == System.Data.ConnectionState.Connecting)
                        _conn.Close();

                if (rdr != null)
                    if (!rdr.IsClosed)
                        rdr.Close();
            }

            Console.WriteLine("Complete");
            Console.ReadLine();
            return;
        }
    }
}
