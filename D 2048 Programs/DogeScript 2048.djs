so ../lib/node-canvas as Canvas
so fs
very Image is Canvas.Image;
very font is '24px ComicSansMS';

such woof much path words callbark
    such bark much err data
        rly err not null
            plz callbark with err null
        wow

        rly err is null
            very img is new Image
            img.src is data;
            very w is img.width
            very h is img.height
            very canv is new Canvas with w h
            very context is plz canv.getContext with '2d'
            context.textDrawingMode is 'glyph';
            context.font is font;
            plz context.drawImage with img 0 0 w h 0 0 w h
            very bounds is new Array with 0
            very length is words.length + 2
            much very i as 0 next i lesser length next i more 1
                very word is words[i]
                rly word not undefined
                    very prefix is plz rollword
                    word is prefix + ' ' + word
                wow
                rly word is undefined
                    word is 'wow';
                wow
                very bound is plz wordbound with word context
                plz bounds.push with bound
                very x is plz rollposition with 1 w
                very y is plz rollposition with 1 h
                very color is plz rollcolor
                context.strokeStyle is color

                plz context.strokeText with word x y
            wow

            very comp is plz path.split with '/'
            very pos is comp.length - 1
            very file is comp[pos]
            very outpath is __dirname + '/../images/' + file

            very out is plz fs.createWriteStream with outpath
            very stream is plz canv.createJPEGStream with {bufsize: 2048, quality: 80}
            plz stream.pipe with out

            plz stream.on with 'end' finish

            such finish
                plz callbark with null file
            wow
        wow
    wow

    plz fs.readFile with path bark
wow

such wordbound much word context
    very measure is plz context.measureText with word
    very bound is {
        'height': measure.height,
        'width': measure.width
    }
wow bound

such rollposition much min max
    very random is plz Math.random
    random is random * max
    random is random + min
    random is plz Math.floor with random
wow random

such rollcolor
    very random is plz Math.random
    random is random * 16777215
    very hexnum is plz Math.floor with random
    very hexstr is plz hexnum.toString with 16
    very hex is '#' + hexstr
wow hex

such rollword
    very words is new Array with 'wow' 'such' 'so' 'much' 'very'
    very num is plz rollposition with 0 4
    very word is words[num];
wow word

very dogeme is {
    'woof': woof
}

module.exports is dogeme
