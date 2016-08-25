using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeSnippets
{
    /// <summary>
    /// 字符串相似度计算类
    /// </summary>
    public static class SimilarityExtensions
    {
        /// <summary>
        /// Levenshtein Distance算法(编辑距离算法）
        /// </summary>
        /// <param name="source">源字符串</param>
        /// <param name="target">目标字符串</param>
        /// <returns></returns>
        private static int ComputeLevenshteinDistance(this string source, string target)
        {
            if (string.IsNullOrEmpty(source))
                return string.IsNullOrEmpty(target) ? 0 : target.Length;
            if (string.IsNullOrEmpty(target))
                return string.IsNullOrEmpty(source) ? 0 : source.Length;
            int sourceLength = source.Length;
            int targetLength = target.Length;
            int[,] distance = new int[sourceLength + 1, targetLength + 1];
            for (int i = 0; i <= sourceLength; distance[i, 0] = i++) ;
            for (int j = 0; j <= targetLength; distance[0, j] = j++) ;

            for (int i = 1; i <= sourceLength; i++)
            {
                for (int j = 1; j <= targetLength; j++)
                {
                    int cost = (target[j - 1] == source[i - 1]) ? 0 : 1;
                    distance[i, j] = Math.Min(
                                        Math.Min(distance[i - 1, j] + 1, distance[i, j - 1] + 1),
                                        distance[i - 1, j - 1] + cost);
                }
            }
            return distance[sourceLength, targetLength];
        }

        /// <summary>
        /// 按顺序比较
        /// </summary>
        /// <param name="source">源字符串</param>
        /// <param name="target">目标字符串</param>
        /// <returns></returns>
        private static double ComputeResembleWithOrder(this string source, string target)
        {
            if (string.IsNullOrEmpty(source))
                return string.IsNullOrEmpty(target) ? 0 : target.Length;
            if (string.IsNullOrEmpty(target))
                return string.IsNullOrEmpty(source) ? 0 : source.Length;
            int sourceLength = source.Length;
            int targetLength = target.Length;
            int len = 0, num = 0;
            string tempA, tempB;
            if (sourceLength >= targetLength)
            {
                while (len < targetLength)
                {
                    tempA = source.Substring(len, 1);
                    tempB = target.Substring(len, 1);
                    if (tempA == tempB)
                        num++;
                    else
                        break;
                    len++;
                }
                return num * 1.0 / sourceLength;
            }
            else if (sourceLength < targetLength)
            {
                while (len < sourceLength)
                {
                    tempA = source.Substring(len, 1);
                    tempB = target.Substring(len, 1);
                    if (tempA == tempB)
                        num++;
                    else
                        break;
                    len++;
                }
                return num * 1.0 / targetLength;
            }
            return 0;
        }

        /// <summary>
        /// 计算字符串相似度
        /// </summary>
        /// <param name="source">源字符串</param>
        /// <param name="target">目标字符串</param>
        /// <returns></returns>
        public static double CalculateSimilarity(this string source, string target)
        {
            if (string.IsNullOrEmpty(source))
                return string.IsNullOrEmpty(target) ? 1 : 0;
            if (string.IsNullOrEmpty(target))
                return string.IsNullOrEmpty(source) ? 1 : 0;
            double deffIndex = 0;
            for (int i = 0; i < target.Length; i++)
            {
                if (i < source.Length && source[i] == target[i])
                {
                    deffIndex++;
                }
            }
            double stepsToSame = ComputeLevenshteinDistance(source, target);
            double resembleOrder = ComputeResembleWithOrder(source, target);
            double result = (stepsToSame == source.Length && stepsToSame == target.Length) ? 0.5 : stepsToSame / (double)Math.Max(source.Length, target.Length);
            result = (1.0 - result) - ((1 - resembleOrder) * 0.001);
            if (result < 1 && (source.Contains(target) || target.Contains(source)))
            {
                result = result + (0.09 * 0.001);
            }
            return result > 1 ? 1 : result;
        }
    }
}
