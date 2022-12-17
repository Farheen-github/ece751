% Get input from file
function result = trunc_mult(opA, opB, k);
    % Make sure opA are single floats
    opAsfp = single(opA);
    opBsfp = single(opB);

    % Record Normal mult
    normalFpResult = opAsfp * opBsfp;
    
    % Casting
    opAuint = typecast(opAsfp, 'uint32');
    opBuint = typecast(opBsfp, 'uint32');
    
    % sign
    signA = getSign(opAuint);
    signB = getSign(opBuint);
    
    % exp
    expA = getExp(opAuint);
    expB = getExp(opBuint);

    % Mantissa
    fracA = getFrac(opAuint);
    fracB = getFrac(opBuint);

    % Hidden 24th bit for mantissa
    tempmask = uint32(0x800000);
    if(expA ~= 0)
        fracA = bitor(fracA, tempmask);
    end
    if(expB ~= 0)
        fracB = bitor(fracB, tempmask);
    end

    % Mask gen
    mask = uint32(0);
    for i = (0:24-1)
        if (i < k)
            mask = bitor(mask, uint32(0x1));
        end
        mask = bitshift(mask, 1);
    end
    fracA = bitand(fracA, mask);
    fracB = bitand(fracB, mask);
    
    % Product
    foilSum = uint64(uint64(fracA) * uint64(fracB));
    
    % product round
    productRound = bitand(foilSum, uint64(0x7FFFFF));
    
    % Normalised
    normalised = bitand(foilSum, uint64(0x800000000000));

    % product Normalised
    productNormalised = uint64(0);
    if (normalised  ~= 0)
        productNormalised = foilSum;
    else
        productNormalised = bitshift(foilSum, 1);
    end

    %product Mantissa
    temp1 = bitand(productNormalised, uint64(0x7FFFFF000000));
    temp1 = bitshift(temp1, -24);
    temp2 = uint64(0);
    if (bitand(productNormalised, uint64(0x800000)) ~= 0 && productRound ~= 0)
        temp2 = uint64(1);
    end
    resultFrac = uint32(temp1+temp2);

    % Exponent
    resultExp = int32(uint32(expA) + uint32(expB));
    if (bitand(productNormalised, uint64(0x800000)) ~= 0)
        resultExp = resultExp + 1;
    end
    resultExp = resultExp - 127;
    underflow = 0;
    if (resultExp < 0)
        underflow = 1;
    end
    resultExp = uint32(resultExp);

    % Sign
    resultSign = bitxor(signA, signB);

    % Zero Check
    zero = 0;
    if (opAuint == 0 || opBuint == 0)
        zero = 1;
    end

    % Overflow Check
    overflow = 0;
    if ((bitand(uint32(resultExp), uint32(0x100)) ~= 0) && ~(bitand(uint32(resultExp), uint32(0x80))) && ~(zero == 1))
        overflow = 1;
    end

    % underflow Check
    if ((bitand(uint32(resultExp), uint32(0x100)) ~= 0) && (bitand(uint32(resultExp), uint32(0x80)) ~= 0) && ~(zero == 1))
        underflow = 1;
    end

    result = single(0);
    if (overflow == 1)
        result = sfp_setup(resultSign,uint32(0xFF),uint32(0));
    elseif (zero == 1)
        result = sfp_setup(resultSign,uint32(0),uint32(0));
    elseif (underflow == 1)
        result = sfp_setup(resultSign,uint32(0),uint32(1));
    else
        result = sfp_setup(resultSign,resultExp,resultFrac);
    end
    
    percentDiff = (normalFpResult - result)/abs(normalFpResult) * 100;
    %fprintf("FOIL result: %f\t", result);
    %fprintf("Normal result: %f\t",normalFpResult);
    %fprintf("%%Diff: %f\n", percentDiff);

    r = percentDiff;
end

% Get input from file
function result = drum_mult(opA, opB, k);
    % Make sure opA are single floats
    opAsfp = single(opA);
    opBsfp = single(opB);

    % Record Normal mult
    normalFpResult = opAsfp * opBsfp;
    
    % Casting
    opAuint = typecast(opAsfp, 'uint32');
    opBuint = typecast(opBsfp, 'uint32');
    
    % sign
    signA = getSign(opAuint);
    signB = getSign(opBuint);
    
    % exp
    expA = getExp(opAuint);
    expB = getExp(opBuint);

    % Mantissa
    fracA = getFrac(opAuint);
    fracB = getFrac(opBuint);
    
    % Hidden 24th bit for mantissa
    hiddenA = 1;
    hiddenB = 1;
    if(expA == 0)
        hiddenA = 0;
    end
    if(expB == 0)
        hiddenB = 0;
    end

    % init foil vars
    fracAh = uint32(fracA);
    fracBh = uint32(fracB);
    if (hiddenA == 1)
        fracAh = bitor(fracAh, uint32(0x800000));
    end
    if (hiddenB == 1)
        fracBh = bitor(fracBh, uint32(0x800000));
    end
    

    uint32 lodA;
    uint32 lodB;
    lodA = LoD(fracAh, uint32(24), uint32(k));
    lodB = LoD(fracBh, uint32(24), uint32(k));
    
    foilSum = uint64(uint64(lodA) * uint64(lodB));
    
    % product round
    productRound = bitand(foilSum, uint64(0x7FFFFF));
    
    % Normalised
    normalised = bitand(foilSum, uint64(0x800000000000));

    % product Normalised
    productNormalised = uint64(0);
    if (normalised  ~= 0)
        productNormalised = foilSum;
    else
        productNormalised = bitshift(foilSum, 1);
    end

    %product Mantissa
    temp1 = bitand(productNormalised, uint64(0x7FFFFF000000));
    temp1 = bitshift(temp1, -24);
    temp2 = uint64(0);
    if (bitand(productNormalised, uint64(0x800000)) ~= 0 && productRound ~= 0)
        temp2 = uint64(1);
    end
    resultFrac = uint32(temp1+temp2);

    % Exponent
    resultExp = int32(uint32(expA) + uint32(expB));
    if (bitand(productNormalised, uint64(0x800000)) ~= 0)
        resultExp = resultExp + 1;
    end
    resultExp = resultExp - 127;
    underflow = 0;
    if (resultExp < 0)
        underflow = 1;
    end
    resultExp = uint32(resultExp);

    % Sign
    resultSign = bitxor(signA, signB);
    
    % Zero Check
    zero = 0;
    if (opAuint == 0 || opBuint == 0)
        zero = 1;
    end

    % Overflow Check
    overflow = 0;
    if ((bitand(uint32(resultExp), uint32(0x100)) ~= 0) && ~(bitand(uint32(resultExp), uint32(0x80))) && ~(zero == 1))
        overflow = 1;
    end

    % underflow Check
    if ((bitand(uint32(resultExp), uint32(0x100)) ~= 0) && (bitand(uint32(resultExp), uint32(0x80)) ~= 0) && ~(zero == 1))
        underflow = 1;
    end

    result = single(0);
    if (overflow == 1)
        result = sfp_setup(resultSign,uint32(0xFF),uint32(0));
    elseif (zero == 1)
        result = sfp_setup(resultSign,uint32(0),uint32(0));
    elseif (underflow == 1)
        result = sfp_setup(resultSign,uint32(0),uint32(1));
    else
        result = sfp_setup(resultSign,resultExp,resultFrac);
    end
    percentDiff = (normalFpResult - result)/abs(normalFpResult) * 100;
    %fprintf("DRUM result: %f\t", result);
    %fprintf("Normal result: %f\t",normalFpResult);
    %fprintf("%%Diff: %f\n", percentDiff);

    r = percentDiff;
end

% Get input from file
function result = foil_mult(opA, opB, k);
    % Make sure opA are single floats
    opAsfp = single(opA);
    opBsfp = single(opB);

    % Record Normal mult
    normalFpResult = opAsfp * opBsfp;
    
    % Casting
    opAuint = typecast(opAsfp, 'uint32');
    opBuint = typecast(opBsfp, 'uint32');
    
    % sign
    signA = getSign(opAuint);
    signB = getSign(opBuint);
    
    % exp
    expA = getExp(opAuint);
    expB = getExp(opBuint);

    % Mantissa
    fracA = getFrac(opAuint);
    fracB = getFrac(opBuint);
    
    % Hidden 24th bit for mantissa
    hiddenA = 1;
    hiddenB = 1;
    if(expA == 0)
        hiddenA = 0;
    end
    if(expB == 0)
        hiddenB = 0;
    end

    % init foil vars
    foilAVal = uint64(0);
    foilBVal = uint64(0);
    foilCVal = uint64(0);
    if (hiddenA == 1 && hiddenB == 1)
       foilAVal = uint64(0x0000400000000000);
    end
    if (hiddenA == 1)
        foilBVal = bitshift(uint64(fracB), 23);
    end
    if (hiddenB == 1)
        foilCVal = bitshift(uint64(fracA), 23);
    end
    

    uint32 lodA;
    uint32 lodB;
    lodA = LoD(fracA, uint32(23), uint32(k));
    lodB = LoD(fracB, uint32(23), uint32(k));

    %want to adjust all numbers to be fixed point
    %foilD is problem
    % want to shift A, B, and C to be the same exponent as D component
    foilDVal = uint64(uint64(lodA) * uint64(lodB));
    
    % Product
    foilSum = uint64(foilAVal + foilBVal + foilCVal + foilDVal);
    
    % product round
    productRound = bitand(foilSum, uint64(0x7FFFFF));
    
    % Normalised
    normalised = bitand(foilSum, uint64(0x800000000000));

    % product Normalised
    productNormalised = uint64(0);
    if (normalised  ~= 0)
        productNormalised = foilSum;
    else
        productNormalised = bitshift(foilSum, 1);
    end

    %product Mantissa
    temp1 = bitand(productNormalised, uint64(0x7FFFFF000000));
    temp1 = bitshift(temp1, -24);
    temp2 = uint64(0);
    if (bitand(productNormalised, uint64(0x800000)) ~= 0 && productRound ~= 0)
        temp2 = uint64(1);
    end
    resultFrac = uint32(temp1+temp2);

    % Exponent
    resultExp = int32(uint32(expA) + uint32(expB));
    if (bitand(productNormalised, uint64(0x800000)) ~= 0)
        resultExp = resultExp + 1;
    end
    resultExp = resultExp - 127;
    underflow = 0;
    if (resultExp < 0)
        underflow = 1;
    end
    resultExp = uint32(resultExp);

    % Sign
    resultSign = bitxor(signA, signB);

    % Zero Check
    zero = 0;
    if (opAuint == 0 || opBuint == 0)
        zero = 1;
    end

    % Overflow Check
    overflow = 0;
    if ((bitand(uint32(resultExp), uint32(0x100)) ~= 0) && ~(bitand(uint32(resultExp), uint32(0x80))) && ~(zero == 1))
        overflow = 1;
    end

    % underflow Check
    if ((bitand(uint32(resultExp), uint32(0x100)) ~= 0) && (bitand(uint32(resultExp), uint32(0x80)) ~= 0) && ~(zero == 1))
        underflow = 1;
    end

    result = single(0);
    if (overflow == 1)
        result = sfp_setup(resultSign,uint32(0xFF),uint32(0));
    elseif (zero == 1)
        result = sfp_setup(resultSign,uint32(0),uint32(0));
    elseif (underflow == 1)
        result = sfp_setup(resultSign,uint32(0),uint32(1));
    else
        result = sfp_setup(resultSign,resultExp,resultFrac);
    end
    
    percentDiff = (normalFpResult - result)/abs(normalFpResult) * 100;
    %fprintf("FOIL result: %f\t", result);
    %fprintf("Normal result: %f\t",normalFpResult);
    %fprintf("%%Diff: %f\n", percentDiff);

    r = percentDiff;
end


function r = getSign(in)
    signMask = uint32(0x80000000);
    signShift = int32(31);
    val = uint32(in);
    masked_val = bitand(val, signMask);
    masked_shifted_val = bitshift(masked_val, -signShift,'uint32');
    r = masked_shifted_val;
end

function r = getExp(in)
    expMask = uint32(0x7f800000);
    expShift = int32(23);
    val = uint32(in);
    masked_val = bitand(val, expMask);
    masked_shifted_val = bitshift(masked_val, -expShift,'uint32');
    r = masked_shifted_val;
end

function r = getFrac(in)
    fracMask = uint32(0x007fffff);
    fracShift = int32(0);
    val = uint32(in);
    masked_val = bitand(val, fracMask);
    masked_shifted_val = bitshift(masked_val, -fracShift,'uint32');
    r = masked_shifted_val;
end

% given shifted fractional portion a
% and number of bits in chunk k
% return LoD b bits
function r = LoD(a, numBits, k)
    % start by checking first bit
    frac_size = uint32(numBits);
    temp = uint32(a);

    % loop to find index
    index = -1;
    for i = (0:frac_size-1)
        mask = uint32(0x00000001);
        if (bitand(mask, temp) == 1)
            % One Detected
            index = i;
        end
        mask = bitshift(uint32(mask), 1);
        temp = bitshift(uint32(temp), -1);
    end

    % Find location of mask start
    r = uint32(0);
    if (index < k)
        % generate Mask
        lodMask = uint32(0);
        for i = (0:k-1)
            lodMask = bitor(lodMask, uint32(0x00000001));
            lodMask = bitshift(lodMask, 1);
        end
        r = bitand(lodMask, uint32(a));
    else 
        % generate Mask
        lodMask = uint32(0);
        round = uint32(0);
        for i = (0:index-1)
            if (i < k)
                lodMask = bitor(lodMask, uint32(0x00000001));
            end
            if (i == k-1)
                round = bitor(round, uint32(0x00000001));
            end
            lodMask = bitshift(lodMask, 1);
            round = bitshift(round, 1);
        end
        r = bitand(lodMask, uint32(a));
        r = bitor(round, uint32(r));
    end 
end

function r = sfp_setup(sign, exp, frac)
    result = bitshift(bitand(sign, uint32(0x1)), 31);
    result = bitor(result, bitshift(bitand(exp,0xeffff), 23));
    result = bitor(result,bitand(frac,0x007fffff));
    %this typecast changes the value
    r = typecast(uint32(result), 'single');
end

%Store results in output file