class MyImage {
    // ...
}

async function readImage(
    path: string, callback: (err: Error, image: MyImage) => void
) : Promise<MyImage>
{
    return await new MyImage()
}

function readImageSync(path: string) : MyImage {
    return new MyImage()
}