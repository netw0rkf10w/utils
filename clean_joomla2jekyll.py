import os
import argparse

def argparsing():
    """
    Reading arguments and call the train function
    """
    # Training settings
    parser = argparse.ArgumentParser(description='Reporting',
                                     fromfile_prefix_chars='@')
    parser.add_argument('-I', '--input-dir', type=str, required=True,
                        help="Path to folder containing original markdown files")
    parser.add_argument('-O', '--output-dir', type=str, default=None,
                        help="Path to output folder")
    return parser


def clean(text):
    t = text.replace('<p><span style="font-size: 14pt;">', "")
    t = t.replace('</span></p>', '\n')
    t = t.replace('<p><br /><span style="font-size: 14pt;">', "")
    t = t.replace('</span><br /><span style="font-size: 14pt;">', "")
    t = t.replace('src="images/', 'src="/assets/images/')
    t = t.replace('href="images/', 'href="/assets/images/')
    t = t.replace('<p> </p>', '')
    t = t.replace('p style="text-align: justify;"> </p>', '')
    t = t.replace('<p style="text-align: justify;">', '')
    t = t.replace('<span style="font-size: 12pt;">', '')
    t = t.replace('<p><span style="font-size: 10pt;">', '')
    return t

def main():
    parser = argparsing()
    args = parser.parse_args()

    input_dir = args.input_dir
    output_dir = args.output_dir
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)

    for fname in os.listdir(input_dir):
        if not fname.endswith('.markdown'):
            continue
        path = os.path.join(input_dir, fname)
        print(f'Processing {path}')
        if os.path.isfile(path):
            # Reade the file
            with open(path, 'r') as f :
                text = f.read()
                text = clean(text)

            # Write the file out again
            with open(path, 'w') as f:
                f.write(text)

if __name__ == "__main__":
    main()