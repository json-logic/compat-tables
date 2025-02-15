using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace JsonLogic.Tests.Models
{
    public class TestCase
    {
        [JsonProperty("description")]
        public string? Description { get; set; }

        [JsonProperty("rule")]
        public JToken? Logic { get; set; }

        [JsonProperty("data")]
        public JToken? Data { get; set; }

        [JsonProperty("result")]
        public JToken? ExpectedValue { get; set; }

        [JsonProperty("error")]
        public JToken? ExpectedError { get; set; }

        public override string ToString()
        {
            return $"TestCase {{ Description = {Description}, Logic = {Logic}, Data = {Data}, ExpectedValue = {ExpectedValue}, ExpectedError = {ExpectedError} }}";
        }
    }
}