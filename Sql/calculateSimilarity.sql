/******获取两个字符串相似度******/
CREATE FUNCTION [dbo].[calculateSimilarity](@s1 nvarchar(3999), @s2 nvarchar(3999))
RETURNS decimal(18,15)
AS
BEGIN
	DECLARE @result decimal(18,15) 
	IF(@s1=@s2)
		BEGIN
			SET @result=1;
		END  
	ELSE IF(LEN(@s1)=0 OR LEN(@s2)=0)
		BEGIN
			SET @result=0;
		END
    ELSE
		BEGIN
			 DECLARE @s1_len int, @s2_len int
			 DECLARE @i int, @j int, @s1_char nchar, @c int, @c_temp int
			 DECLARE @cv0 varbinary(8000), @cv1 varbinary(8000)
			 DECLARE @max_len int
			 SELECT @s1_len = LEN(@s1),@s2_len = LEN(@s2),@cv1 = 0x0000,@j = 1, @i = 1,@c = 0
			 IF @s1_len>=@s2_len 
				BEGIN
					SET @max_len=@s1_len
				END
			 Else
				BEGIN
					SET @max_len=@s2_len
				END
			 WHILE @j <= @s2_len
				SELECT @cv1 = @cv1 + CAST(@j AS binary(2)), @j = @j + 1

			 WHILE @i <= @s1_len
			 BEGIN
			  SELECT
			   @s1_char = SUBSTRING(@s1, @i, 1),
			   @c = @i,
			   @cv0 = CAST(@i AS binary(2)),
			   @j = 1
			  WHILE @j <= @s2_len
			  BEGIN
			   SET @c = @c + 1
			   SET @c_temp = CAST(SUBSTRING(@cv1, @j+@j-1, 2) AS int) +
				CASE WHEN @s1_char = SUBSTRING(@s2, @j, 1) THEN 0 ELSE 1 END
			   IF @c > @c_temp SET @c = @c_temp
			   SET @c_temp = CAST(SUBSTRING(@cv1, @j+@j+1, 2) AS int)+1
			   IF @c > @c_temp SET @c = @c_temp
			   SELECT @cv0 = @cv0 + CAST(@c AS binary(2)), @j = @j + 1
			 END
			 SELECT @cv1 = @cv0, @i = @i + 1
			 END
			 DECLARE @num FLOAT,@len int
			  SET @s1=ISNULL(@s1,0)
			  SET @s2=ISNULL(@s2,0)
			  SET @len=1
			  SET @num=0
			  WHILE(@s1_len<>0 AND @s2_len<>0)
			  BEGIN
			  DECLARE @a NVARCHAR(4)
			  DECLARE @b NVARCHAR(4)
				IF(@s1_len>=@s2_len)
				BEGIN
				  WHILE(@len<=@s2_len)
				  BEGIN
					SET @a=''
					SET @a=SUBSTRING(@s1,@len,1)
					SET @b=''
					SET @b=SUBSTRING(@s2,@len,1)
					IF(@a=@b)
					BEGIN
					SET @num=@num+1
					END
					  ELSE
					  BEGIN
						break
					  END
				  SET  @len=@len+1   
				  END
				END
				ELSE IF	(@s1_len<@s2_len)
				BEGIN
				  WHILE(@len<=@s1_len)
					BEGIN
					  SET @a=''
					  SET @a=SUBSTRING(@s1,@len,1)
					  SET @b=''
					  SET @b=SUBSTRING(@s2,@len,1)
					  IF(@a=@b)
					  BEGIN
						SET @num=@num+1
					  END
					  ELSE
						BEGIN
						  break
						END
					SET  @len=@len+1   
				  END
				END
			  BREAK
			  END
				DECLARE @stepsToSame DECIMAL(18,15)
				SET @stepsToSame=@c;
				DECLARE @resembleOrder DECIMAL(18,15)
				SET @resembleOrder=(cast(@num as decimal(18,15)) /@max_len);
				IF(@stepsToSame=@s1_len AND @stepsToSame=@s2_len)
					BEGIN
						SET @result=0.5;
                    END
				ELSE
					BEGIN
						SET @result=(cast(@stepsToSame as decimal(18,15))) / @max_len
                    END
				SET @result= (1.0 - @result) - ((1 - @resembleOrder) * 0.001); 
				IF (@result<1 AND (CHARINDEX(@s1,@s2)>0 OR CHARINDEX(@s2,@s1)>0))
					BEGIN
						SET @result = @result + (0.09 * 0.001);
					END 
				SET @result=CASE WHEN @result>1 THEN 1 WHEN @result<0 THEN 0 ELSE @result
			END
		END
		RETURN @result
	END
                